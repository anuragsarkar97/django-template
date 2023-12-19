from django.shortcuts import render
from rest_framework import viewsets

from users.models import Team

from users.serializers import TeamSerializer, UserSerializer


# Create your views here.

class TeamViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer


class UserViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.all()
    serializer_class = UserSerializer
