from django.urls import path, include
from rest_framework.routers import DefaultRouter

from projects.views import ProjectViewSet, TaskViewSet, CommentsViewSet
from users.views import TeamViewSet, UserViewSet

# Create a router and register our ViewSets with it.
router = DefaultRouter()
router.register(r'projects', ProjectViewSet, basename='project')
router.register(r'tasks', TaskViewSet, basename='task')
router.register(r'comments', CommentsViewSet, basename='comment')

# The API URLs are now determined automatically by the router.
urlpatterns = [
    path('', include(router.urls)),
]
