from django.conf import settings
from django.db import models


class Bus(models.Model):
    registration_number = models.CharField(max_length=24, unique=True)
    pilot = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name='assigned_buses',
    )
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.registration_number
