from django.contrib import admin

from apps.trips.models import Trip


@admin.register(Trip)
class TripAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'pilot',
        'bus',
        'route',
        'status',
        'start_time',
        'end_time',
    )
    list_filter = ('status',)
    search_fields = ('pilot__username', 'bus__registration_number')
