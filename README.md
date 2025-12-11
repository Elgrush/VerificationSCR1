# Этот репозиторий содержит инструменты для отладки синтокора<scr1> через шину wishbone

# Описание:
В репозитории уже присутствует пример программы, которая выполняет алгоритм QuckSort. <br/>
В схеме присутствуют синтакор, wishbone, вывод GPIO, 2 RAM модуля: в первом программа,
во втором - сортируемый массив, первый элемент которого является числом элементов массива.

# Для работы в PATH должны быть:

Первым делом пропишите `git submodule init && git submodule update` <br/>

# Для работы в PATH должны быть:
[riscv-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/releases/tag/2025.11.04) <br/>
Questa Analyzer (Гайд ниже) <br/>
GTKWave `sudo apt install gtkwave` <br/>

# Гайд по установке Questa
Дальше нужен ВПН:<br/>
[Сайт альтеры](https://www.altera.com/downloads/simulation-tools/questa-fpgas-standard-edition-software-version-25-1), с которого можно скачать Questa<br />
[Сайт интел](https://www.intel.com/content/www/us/en/support/programmable/licensing/support-center.html) с поддержкой по созданию лицензии<br />

# Список утилит
Для компиляциии прошивки:
`make build_firmware`<br/>
Для компиляциии Questa:
`make run_vsim`<br/>

Makefile проекта прозодит этапы в превеенном выше порядке:
`make`<br/>
Открыть итоговую вейформу в GTKwave: `make call_gtkwave`<br/>
Очистка кэша: `make clean`<br/>
Очистка программы: `make clean_firmware`<br/>
Очистка симуляции: `make clean_simulation`<br/>

# FAQ
При проблемах с .svh файлами в квартусе поставьте
`Assignments->Settings->Compiler Settings->Verilog HDL Input = SystemVerilog`
