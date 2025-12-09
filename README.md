Этот репозиторий проведет вас по тернистому пути запуска синтакора на плате через wishbone

Первым делом пропишите git submodule init && git submodule update

Дальше нужен ВПН
[Сайт альтеры](https://www.altera.com/downloads/simulation-tools/questa-fpgas-standard-edition-software-version-25-1), с которого можно скачать Questa:
[Сайт интел](https://www.intel.com/content/www/us/en/support/programmable/licensing/support-center.html) с поддержкой по созданию лицензии

Для компиляциии прошивки
make -f bin/software/makefile

Для компиляциии Questa
make -f bin/simulation/makefile

Makefile проекта прозодит этапы в превеенном выше порядке
make

При проблемах с .svh файлами в квартусе
Assignments->Settings->Compiler Settings->Verilog HDL Input = SystemVerilog
