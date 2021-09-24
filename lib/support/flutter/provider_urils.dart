
enum ModelStatus {
  UNINITIALIZED,
  INITIALIZING,
  INITIALIZED,
}

abstract class ModelUtilMixin {
  ModelStatus status = ModelStatus.UNINITIALIZED;

  bool get initialized => ModelStatus.INITIALIZED == status;
}
