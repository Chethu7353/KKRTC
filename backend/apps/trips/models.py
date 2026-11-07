from django.conf import settings
from django.db import models
from django.db.models import Q

from apps.buses.models import Bus
from apps.routes.models import Route


class Trip(models.Model):
    class Status(models.TextChoices):
        ACTIVE = 'ACTIVE', 'Active'
        COMPLETED = 'COMPLETED', 'Completed'

    pilot = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name='trips',
    )
    bus = models.ForeignKey(Bus, on_delete=models.PROTECT, related_name='trips')
    route = models.ForeignKey(
        Route,
        on_delete=models.PROTECT,
        related_name='trips',
    )
    status = models.CharField(
        max_length=12,
        choices=Status.choices,
        default=Status.ACTIVE,
    )
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ('-start_time',)
        constraints = [
            models.UniqueConstraint(
                fields=('pilot',),
                condition=Q(status='ACTIVE'),
                name='one_active_trip_per_pilot',
            ),
        ]

    def __str__(self):
        return f'{self.route} ({self.status})'
