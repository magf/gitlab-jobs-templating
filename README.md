# gitlab-jobs-templating
Use Jinja2 template for GitLab jobs generation

## Пример использования шаблонизации Jinja2 для динамического создания джоб

### Схема создания дочерних джоб

- Корневая джоба генерирует YAML-файл, в который помещает все дочерние джобы
```yaml
create-build-jobs:
  stage: create-build-jobs
  script:
  - cat ci/default_*.yml > build_jobs.yml
  - j2 templates/build_stages.yml.j2 data/spec.yml >> build_jobs.yml
  - j2 templates/build_jobs.yml.j2 data/spec.yml >> build_jobs.yml
  artifacts:
    name: "$CI_JOB_NAME"
    paths:
    - build_jobs.yml
    expire_in: 10 min
```
- Сохраняет этот файл в артефактах
```yaml
  artifacts:
    name: "$CI_JOB_NAME"
    paths:
    - build_jobs.yml
    expire_in: 10 min
```
- Инициирует триггер, который запускает дочернюю джобу, в которой разворачивается созданный файл
```yaml
build-jobs:
  stage: build-jobs
  trigger:
    include:
    - artifact: build_jobs.yml
      job: create-build-jobs
```
### Механизм шаблонизации

В процессе формирования дочерних джоб используется шаблонизатор [Jinja2](https://ru.wikipedia.org/wiki/Jinja) и утилита командной строки [j2](https://github.com/kolypto/j2cli), которая позволяет накладывать на шаблон структуру данных.

ВАЖНО! - утилита [j2](https://github.com/kolypto/j2cli) должна быть установлена на раннере (в контейнере), где будет выполняться. Ей нужен Python, но вместо неё можно использовать и что-то друге, если Вы сможете [найти](https://www.google.com/search?q=j2+template+utility) для себя более подходящий вариант.

Таким образом, команда `j2 templates/build_stages.yml.j2 data/spec.yml >> build_jobs.yml` формирует уровень необходимых стейджей для дочернего пайплайна путём наложения файла спецификаций `data/spec.yml` на шаблон `templates/build_stages.yml.j2`, а команда `j2 templates/build_jobs.yml.j2 data/spec.yml >> build_jobs.yml` формирует тела самих джоб, соответственно.


