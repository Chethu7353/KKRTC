from django.contrib import admin

from apps.buses.models import Bus


@admin.register(Bus)
class BusAdmin(admin.ModelAdmin):
    list_display = ('registration_number', 'pilot', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('registration_number', 'pilot__username')
