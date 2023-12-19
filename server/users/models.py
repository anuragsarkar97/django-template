import random

from django.db import models

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db.models.signals import pre_save
from django.dispatch import receiver


class Team(models.Model):
    name = models.CharField(max_length=30)
    slang = models.CharField(max_length=30)
    description = models.TextField(max_length=1000)
    homepage_url = models.URLField()
    parent_team = models.ForeignKey('self', on_delete=models.CASCADE, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    random = models.FloatField()

    class Meta:
        indexes = [
            models.Index(fields=['slang']),
            models.Index(fields=['parent_team']),
        ]


class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None):
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(
            email=self.normalize_email(email),
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password):
        user = self.create_user(
            email=email,
            password=password,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser):
    email = models.EmailField(verbose_name='email address', max_length=255, unique=True)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    random = models.FloatField()
    signed_up_ip = models.GenericIPAddressField()

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    @property
    def is_staff(self):
        return self.is_admin


class UserAction(models.Model):
    action = models.CharField(max_length=30)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    metadata = models.JSONField()
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    random = models.FloatField()

    class Meta:
        indexes = [
            models.Index(fields=['action', 'user', 'team']),
            models.Index(fields=['action', 'user', 'team', 'created_at']),
        ]


@receiver(pre_save)
def random_filler_callback(sender, instance, *args, **kwargs):
    instance.random = random.random()


@receiver(pre_save, sender=User)
def create_team_fresh_user_callback(sender, instance, *args, **kwargs):
    if instance.team is None:
        team = Team()
        team.name = "Team 1"
        team.save()
        instance.team = team
    if instance.signed_up_ip is None:
        instance.signed_up_ip = '1.2.3.4'
