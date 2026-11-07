from django.contrib import admin

from apps.routes.models import Route


@admin.register(Route)
class RouteAdmin(admin.ModelAdmin):
    list_display = ('source_name', 'destination_name', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('source_name', 'destination_name')
