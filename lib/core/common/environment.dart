
Environment currentEnvironment = Environment.dev;

enum Environment { dev, stg, prod }

abstract class EnvironmentData<D> {
  D dev();

  D stg();

  D prod();

  D getData() {
    switch (currentEnvironment) {
      case Environment.dev:
        return dev();
      case Environment.stg:
        return stg();
      case Environment.prod:
        return prod();
    }
  }
}

