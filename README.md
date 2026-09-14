Домашнее задание к занятию «Продвинутые методы работы с Terraform»

Задание 1. Remote module

Созданы две виртуальные машины с использованием remote-модуля:

marketing

analytics

Для определения принадлежности используются labels:

labels = {
  project = "marketing"
}

labels = {
  project = "analytics"
}

SSH-ключ передаётся в cloud-init.yml через переменную:

data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    ssh_public_key = file(pathexpand(var.ssh_public_key_path))
  }
}

В cloud-init.yml выполняется установка nginx:

packages:
  - nginx
  - vim

runcmd:
  - systemctl enable nginx
  - systemctl start nginx

Проверка nginx:

sudo nginx -t

Проверка модулей через Terraform console:

module.marketing_vm
module.analytics_vm

Скриншоты для задания 1

Нужно приложить:

ВМ marketing и analytics в Yandex Cloud с labels

подключение по SSH

результат sudo nginx -t

вывод module.marketing_vm

вывод module.analytics_vm

Задание 2. Локальный модуль VPC

Создан локальный модуль:

vpc/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── README.md

Вызов локального модуля:

module "vpc_dev" {
  source = "./vpc"

  env_name = var.vpc_name
  zone     = var.default_zone
  cidr     = var.default_cidr[0]
}

Модуль создаёт:

одну VPC network

одну subnet

Ресурсы сети были перенесены в модуль без физического пересоздания:

terraform state mv 'yandex_vpc_network.develop' 'module.vpc_dev.yandex_vpc_network.this'

terraform state mv 'yandex_vpc_subnet.develop' 'module.vpc_dev.yandex_vpc_subnet.this'

После переноса:

No changes. Your infrastructure matches the configuration.

Проверка модуля через Terraform console:

module.vpc_dev

Документация локального модуля сгенерирована с помощью:

terraform-docs markdown table ./vpc > ./vpc/README.md

Задание 3. Работа с Terraform state

Список ресурсов:

terraform state list

В state находились:

data.template_file.cloudinit
module.analytics_vm.data.yandex_compute_image.my_image
module.analytics_vm.yandex_compute_instance.vm[0]
module.marketing_vm.data.yandex_compute_image.my_image
module.marketing_vm.yandex_compute_instance.vm[0]
module.vpc_dev.yandex_vpc_network.this
module.vpc_dev.yandex_vpc_subnet.this

Удаление модулей из state:

terraform state rm 'module.vpc_dev'
terraform state rm 'module.marketing_vm'
terraform state rm 'module.analytics_vm'

Физически ресурсы в Yandex Cloud при этом не удалялись.

Импорт VPC обратно в state:

terraform import 'module.vpc_dev.yandex_vpc_network.this' enpusu79489da6kvdagl

terraform import 'module.vpc_dev.yandex_vpc_subnet.this' e9bu4d5jonnbsgsb1176

Импорт виртуальной машины marketing:

terraform import 'module.marketing_vm.yandex_compute_instance.vm[0]' fhmo83adnklh5tpsfjgl

Импорт виртуальной машины analytics:

terraform import 'module.analytics_vm.yandex_compute_instance.vm[0]' fhm8i091a09qeg8cil3s

После импорта:

terraform plan

Terraform показал:

Plan: 0 to add, 2 to change, 0 to destroy.

Изменения касались только:

allow_stopping_for_update = true

После применения конфигурации выполняется повторная проверка:

terraform plan

Ожидаемый итог:

No changes. Your infrastructure matches the configuration.

Итог

В ходе работы:

использованы remote-модули Terraform

создано две виртуальные машины marketing и analytics

настроены labels

SSH-ключ передаётся через переменную в cloud-init

nginx устанавливается автоматически

создан собственный локальный модуль VPC

документация модуля сгенерирована через terraform-docs

выполнен перенос ресурсов в Terraform state

выполнено удаление ресурсов из state без удаления инфраструктуры

выполнен обратный импорт VPC и виртуальных машин

инфраструктура проверена командой terraform plan

Репозиторий:

https://github.com/wwwsokol999-ui/terraform-04
