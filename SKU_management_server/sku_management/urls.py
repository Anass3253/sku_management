from django.urls import path
from . import views

urlpatterns = [
    path('', views.myApp),
    path('add_branch/', views.AddBranchView.as_view(), name='add-branch'),
    path('item_management/', views.ItemManagementView.as_view(), name='item-management'),
    path('item_deactivation/', views.DeactivateItem.as_view(), name='item-deactivation'),
    path('codes_generator/', views.generateCodes.as_view(), name='codes-generator'),
]  