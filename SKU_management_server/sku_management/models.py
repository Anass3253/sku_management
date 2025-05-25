from django.db import models
import uuid

# Create your models here.

class InventoryBranch(models.Model):
    branch_id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    branch_name = models.CharField(max_length=100)
    branch_location = models.CharField(max_length=100)
    branch_phone = models.CharField(max_length=15)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'inventory_branch'
        
    def __str__(self):
        return f"{self.branch_name} ({self.branch_location})"
    

class ItemManagement(models.Model):
    item_id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    item_name = models.CharField(max_length=100, unique=True)
    category = models.TextField(blank=True, null=True, max_length=50)
    sub_category = models.CharField(max_length=50, null=True, blank=True)
    brand_name = models.CharField(max_length=100)
    sku_code = models.CharField(max_length=100, unique=True)
    is_sku_manual = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'inventory_items'
        
    def __str__(self):
        return self.item_name