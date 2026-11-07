from rest_framework.permissions import BasePermission


class IsAuthenticatedPilot(BasePermission):
    message = 'Only authenticated pilots can start trips.'

    def has_permission(self, request, view):
        user = request.user
        return bool(
            user
            and user.is_authenticated
            and getattr(getattr(user, 'profile', None), 'role', None)
            == 'PILOT'
        )
