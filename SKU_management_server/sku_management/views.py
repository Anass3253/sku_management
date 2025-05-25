from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import InventoryBranch, ItemManagement
from .serializers import BranchSerializer, ItemSerializer
import random
import string
import qrcode
import barcode
from barcode.writer import ImageWriter
import os
from django.conf import settings
# Create your views here.

def myApp(request):
    return render(request, 'main.html')


class AddBranchView(APIView):
    def post(self, request):
        serializer = BranchSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # Saves to Database
            return Response({
                'branch_id': serializer.data['branch_id'],
                'message': 'Branch created successfully!'
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

class ItemManagementView(APIView):
    def get(self, request):
        items = ItemManagement.objects.filter(is_active=True)
        serializer = ItemSerializer(items, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def generate_sku(self, item_name, brand_name, category):
        prefix = f"{brand_name[:3].upper()}-{item_name[:3].upper()}"
        rand_suffix = ''.join(random.choices(string.digits, k=4))
        return f"{prefix}-{rand_suffix}"

    def post(self, request):
        is_manual = request.data.get("isManual")

        data = request.data.copy()

        if not is_manual:  # Auto-generate SKU
            sku_code = self.generate_sku(
                item_name=data.get("item_name"),
                brand_name=data.get("brand_name"),
                category=data.get("category"),
            )
            data["sku_code"] = sku_code
            data["is_sku_manual"] = False
        else:
            data["is_sku_manual"] = True

        serializer = ItemSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DeactivateItem(APIView):
    def delete(self, request):
        sku_code = request.data.get('sku_code')
        try:
            item = ItemManagement.objects.get(sku_code=sku_code)
            item.is_active = False
            item.save()
            return Response({'message': 'Item deactivated successfully!'}, status=status.HTTP_202_ACCEPTED)
        except ItemManagement.DoesNotExist:
            return Response({'error': 'Item not found'}, status=status.HTTP_404_NOT_FOUND)
    

class generateCodes(APIView):
    def post(self, request):
        sku_code = request.data.get('sku_code')
        try:
            item = ItemManagement.objects.get(sku_code=sku_code)

            # Create directory if it doesn't exist
            folder_path = os.path.join(settings.MEDIA_ROOT, 'code_imgs')
            os.makedirs(folder_path, exist_ok=True)

            # Filenames
            qr_filename = f"{item.item_name}_qr.png"
            barcode_filename = f"{item.item_name}_barcode.png"

            qr_path = os.path.join(folder_path, qr_filename)
            barcode_path = os.path.join(folder_path, barcode_filename)

            # Generate QR Code
            qr = qrcode.QRCode(version=1, box_size=10, border=5)
            qr.add_data(item.sku_code)
            qr.make(fit=True)
            img_qr = qr.make_image(fill_color="black", back_color="white")
            img_qr.save(qr_path)

            # Generate Barcode
            barcode_obj = barcode.get('code128', item.sku_code, writer=ImageWriter())
            barcode_obj.save(os.path.splitext(barcode_path)[0])  # Save without .png, writer adds it

            # Full URLs
            qr_url = request.build_absolute_uri(settings.MEDIA_URL + f"code_imgs/{qr_filename}")
            barcode_url = request.build_absolute_uri(settings.MEDIA_URL + f"code_imgs/{barcode_filename}")

            return Response({
                'message': 'Codes generated successfully!',
                'qr_code_url': qr_url,
                'barcode_url': barcode_url
            }, status=status.HTTP_200_OK)

        except ItemManagement.DoesNotExist:
            return Response({'error': 'Item not found'}, status=status.HTTP_404_NOT_FOUND)