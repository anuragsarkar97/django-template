from django.db import models


# Create your models here.


class Project(models.Model):
    name = models.CharField(max_length=30)
    description = models.CharField(max_length=100)
    random = models.FloatField()
    team = models.ForeignKey('users.Team', on_delete=models.CASCADE)
    created_by = models.ForeignKey('users.User', on_delete=models.CASCADE, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [
            models.Index(fields=['random']),
            models.Index(fields=['name']),
        ]


class Task(models.Model):
    name = models.CharField(max_length=30)
    description = models.TextField(max_length=3000)
    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    assigned_to = models.ForeignKey('users.User', on_delete=models.CASCADE, null=True, related_name='assigned_to')
    assigned_by = models.ForeignKey('users.User', on_delete=models.CASCADE, null=True, related_name='assigned_by')
    status = models.CharField(max_length=30)
    priority = models.CharField(max_length=30)
    random = models.FloatField()

    class Meta:
        indexes = [
            models.Index(fields=['project']),
            models.Index(fields=['assigned_to']),
            models.Index(fields=['assigned_by']),
            models.Index(fields=['status']),
            models.Index(fields=['priority']),
        ]


class Comment(models.Model):
    text = models.TextField(max_length=3000)
    task = models.ForeignKey(Task, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    random = models.FloatField()
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    team = models.ForeignKey('users.Team', on_delete=models.CASCADE)

    class Meta:
        indexes = [
            models.Index(fields=['task']),
            models.Index(fields=['random']),
            models.Index(fields=['user']),
            models.Index(fields=['team']),
        ]
