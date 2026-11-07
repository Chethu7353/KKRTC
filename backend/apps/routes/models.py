from django.db import models


class Route(models.Model):
    source_name = models.CharField(max_length=120)
    destination_name = models.CharField(max_length=120)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ('source_name', 'destination_name')
        constraints = [
            models.UniqueConstraint(
                fields=('source_name', 'destination_name'),
                name='unique_route_endpoints',
            ),
        ]

    def __str__(self):
        return f'{self.source_name} - {self.destination_name}'
