Этот репозиторий проведет вас по тернистому пути запуска синтакора на плате через wishbone

Первым делом пропишите git submodule init && git submodule update

Для компиляциии прошивки
make -f bin/software/makefile

Для компиляциии Questa
make -f bin/simulation/makefile

При проблемах с .svh файлами в квартусе
Assignments->Settings->Compiler Settings->Verilog HDL Input = SystemVerilog
