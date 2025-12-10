# Этот репозиторий содержит инструменты для отладки синтокора<scr1> через шину wishbone

Первым делом пропишите git submodule init && git submodule update <br/>

# Для работы в PATH должны быть:
[riscv-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/releases/tag/2025.11.04) <br/>
Questa Analyzer (Гайд ниже) <br/>
GTKWave <br/>

# Гайд по установке Questa
Дальше нужен ВПН:<br/>
[Сайт альтеры](https://www.altera.com/downloads/simulation-tools/questa-fpgas-standard-edition-software-version-25-1), с которого можно скачать Questa<br />
[Сайт интел](https://www.intel.com/content/www/us/en/support/programmable/licensing/support-center.html) с поддержкой по созданию лицензии<br />

# Список утилит
Для компиляциии прошивки:
`make -f bin/software/makefile`<br/>
Для компиляциии Questa:
`make -f bin/simulation/makefile`<br/>

Makefile проекта прозодит этапы в превеенном выше порядке:
`make`<br/>
Открыть итоговую вейформу в GTKwave: `bin/call_gtkwave`<br/>
Очистка кэша: `bin/cleanup.sh`

# FAQ
При проблемах с .svh файлами в квартусе поставьте
`Assignments->Settings->Compiler Settings->Verilog HDL Input = SystemVerilog`
