from rest_framework import serializers
from .models import InventoryBranch, ItemManagement

class BranchSerializer(serializers.ModelSerializer):
    class Meta:
        model = InventoryBranch
        fields = '__all__' 
        

class ItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemManagement  # Assuming you want to serialize InventoryBranch
        fields = '__all__'  # Adjust fields as necessary