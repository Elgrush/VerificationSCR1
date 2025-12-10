#Этот репозиторий проведет вас по тернистому пути запуска синтакора на плате через wishbone

Первым делом пропишите git submodule init && git submodule update <br />

#Для работы в PATH должны быть:
[riscv-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/releases/tag/2025.11.04) <br />
Questa Analyzer (Гайд ниже) <br />
GTKWave <br />

#Гайд по установке Questa
Дальше нужен ВПН<br />
[Сайт альтеры](https://www.altera.com/downloads/simulation-tools/questa-fpgas-standard-edition-software-version-25-1), с которого можно скачать Questa<br />
[Сайт интел](https://www.intel.com/content/www/us/en/support/programmable/licensing/support-center.html) с поддержкой по созданию лицензии<br />

##Для компиляциии прошивки
make -f bin/software/makefile
##Для компиляциии Questa
make -f bin/simulation/makefile

##Makefile проекта прозодит этапы в превеенном выше порядке
make
#FAQ
bin/call_gtkwave открывает итоговую вейформу в gtkwave<br />

##При проблемах с .svh файлами в квартусе
Assignments->Settings->Compiler Settings->Verilog HDL Input = SystemVerilog
