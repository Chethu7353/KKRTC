from django.conf import settings
from django.db import models


class UserProfile(models.Model):
    class Role(models.TextChoices):
        PASSENGER = 'PASSENGER', 'Passenger'
        PILOT = 'PILOT', 'Pilot'

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='profile',
    )
    role = models.CharField(max_length=12, choices=Role.choices)

    def __str__(self):
        return f'{self.user_id}: {self.role}'
