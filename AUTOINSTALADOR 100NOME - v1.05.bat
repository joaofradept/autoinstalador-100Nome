@echo off
chcp 65001 >nul
REM Copyright (C) 2024  João Frade
REM Todos os direitos reservados.
REM Este script (AUTOINSTALADOR 100NOME) foi criado para as traduções do 100Nome.
REM Mais jogos em português em https://100nome.blogs.sapo.pt/
REM Este código é distribuído sob a Licença Pública Geral GNU v3.0, disponível em https://www.gnu.org/licenses/gpl-3.0.html.
REM Este programa vem SEM QUALQUER TIPO DE GARANTIA.
REM A licença completa pode ser acedida a partir do programa ou no final deste script.
REM The full license can be accessed from within the program or at the end of this script.
REM Pode aceder à versão mais recente do código em:
REM https://github.com/joaofradept/autoinstalador-100Nome/.
setlocal EnableDelayedExpansion
TITLE AUTOINSTALADOR 100NOME
set "spContentFolder=_100NOME"
REM Para arrays que contenham elementos com espaços, representar como:
REM set nomeArray="elemento 1" "el 2" "el 3"
REM Para arrays que contenham elementos sem espaços apenas, pode-se representar como:
REM "set nomeArray=elemento1 el2 el3"
REM Para arrays vazios, representar como:
REM "set nomeArray="
set "gameName=Nenhum jogo encontrado"
set "fileName=jogoexemplo.exe"
set "baseUpLevels=0"
set "expectedFiles="
set expectedDirs="Pasta 1" "Pasta 2"
set "filesForRemoval="
set "urlEnd=linkjogoexemplo100Nome"
set "trLicenseFileName=LICENÇA_jogoexemplo.txt"
REM Não alterar nada daqui para baixo.
set "dirsToSearch=C D E F G"
set "exeDir="
set "gameDir="
set "searchedDirs="
set "contentsDir="
set "packName="
set "packStartName=Pacote 100Nome"
set "packDefaultName=pacote normal"
set "trNotesFileName=NOTAS DA TRADUÇÃO.txt"
set "helpFileName=AJUDA 100NOME.txt"
set "backupPath=!spContentFolder!\cópia de segurança"
set "partBackupEnding= - parcial"
set "performBackup=1"
set "installed=0"
set "scriptVersion=1.5.1_220325"

REM Verifica se já está a ser executado como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo A reiniciar o script com permissões de administrador...
    
    REM Relança o script como administrador
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:main-menu-intro
echo                               Copyright (C) 2024  João Frade
echo       Código licenciado sob a Licença Pública Geral GNU v3.0
echo              Este programa vem SEM QUALQUER TIPO DE GARANTIA
echo.
echo  ██╗ ██████╗  ██████╗ ███╗   ██╗ ██████╗ ███╗   ███╗███████╗
ping -n 1 127.0.0.1 >nul
echo ███║██╔═████╗██╔═████╗████╗  ██║██╔═══██╗████╗ ████║██╔════╝
ping -n 1 127.0.0.1 >nul
echo ╚██║██║██╔██║██║██╔██║██╔██╗ ██║██║   ██║██╔████╔██║█████╗  
ping -n 1 127.0.0.1 >nul
echo  ██║████╔╝██║████╔╝██║██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══╝  
ping -n 1 127.0.0.1 >nul
echo  ██║╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝██║ ╚═╝ ██║███████╗
ping -n 1 127.0.0.1 >nul
echo  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝   v%scriptVersion%
ping -n 1 127.0.0.1 >nul
echo.

cd /d "%~dp0"

:loadVariables
REM Caminho para o ficheiro de texto
set "inputFile=autoinstalacao"

REM Variáveis necessárias para a configuração (gerais ao jogo)
set "neededConfigNames=#gameName#urlEnd"
set "existingConfigNames="

REM Lê o ficheiro linha por linha
for /f "tokens=1,* delims= " %%a in (%inputFile%) do (
    set "varName=%%a"
    set "varValue=%%b"
	
    REM Adiciona o nome da variável encontrada à lista de configurações existentes
    set "existingConfigNames=!existingConfigNames!#%%a"

    REM Define a variável com o valor
    set "!varName!=!varValue!"
)

REM echo existing: %existingConfigNames%
REM echo needed  : %neededConfigNames%

:main-menu
echo SCRIPT PARA INSTALAÇÃO AUTOMÁTICA
echo DA TRADUÇÃO DO JOGO: "  %gameName%  "
echo.
echo 100NOME.BLOGS.SAPO.PT
echo.
echo Antes de começar:
echo 1º Certifica-te de que a pasta que contém os pacotes foi extraída do Zip.
echo 2º Certifica-te de que este script foi executado a partir dessa pasta já extraída.
echo.

if not "%existingConfigNames%"=="%neededConfigNames%" (
	echo =========================================================
	echo.
	echo Não é possível continuar com a instalação.
	echo.
	echo Verifica primeiro os pontos acima
	echo e depois se o pacote está preparado para ser autoinstalado.
	echo.
	echo Para uma solução rápida, contacta o 100Nome pelo Discord em:
	echo https://discord.gg/Xv7ax2VkEp
	echo.
	echo Prime qualquer tecla para terminar a instalação.
	pause >nul
	goto :interrupt
)
echo [A] para avançar.
echo [CO] para configurações
echo [LI] para licença do instalador
echo.
set /p "choice=Introduzir letra e premir Enter > "
if /i "!choice!"=="LI" goto :license
if /i "!choice!"=="CO" goto :configs
if /i not "!choice!"=="A" (
	cls
	goto :main-menu-intro
)

:listPacks
set packList=0
set i=-1
REM Ciclo para listar os pacotes encontrados
for /d %%d in (*.*) do (
    set "dir=%%d"
	
    REM Verifica se o diretório começa com o nome especificado
    if /i "!dir:~0,14!"=="%packStartName%" (
	
		REM Verifica se o ficheiro "autoinstalacao" existe dentro do diretório
		if exist "%%d\!inputFile!" (
			set /A i+=1
			set "packList[!i!]=!dir!"
		)
		
    )
)

:packChoice
echo.
echo =========================================================
echo.
REM Verifica quantos pacotes foram encontrados
if %i%==0 (
    echo Está disponível um pacote de tradução para o jogo %gameName%.
	if not "!packList[0]:~14,1!"=="" (
		echo Nome do pacote: !packList[0]:~17!
	)
	echo.
	echo Prime qualquer tecla para avançar.
    pause >nul
    set choice=0
) else if %i% gtr 0 (
	echo Os seguintes pacotes de tradução estão disponíveis para instalação:
    REM Apenas lista pacotes se houver mais de um
    for /L %%n in (0,1,%i%) do (
		set /A num=%%n+1
		set "optionName=!packList[%%n]:~17!"
		if "!packList[%%n]:~14,1!"=="" (
			set "optionName=%packDefaultName%"
		)
        echo [!num!] para !optionName!
    )
    echo.
    echo / Verifica qual é a versão do jogo que tens instalada
    echo e introduz o número correspondente ao pacote a instalar. /
    echo.
    set /p "choice=Introduzir número e premir Enter > "
	set /A choice-=1
) else if %i%==-1 (
	echo Não foi encontrado nenhum pacote válido
	echo no diretório onde se encontra este autoinstalador.
	echo.
	echo Certifica-te de que este script se encontra ao pé dos pacotes de tradução.
	echo.
	echo Prime qualquer tecla para terminar a instalação.
	pause >nul
	goto :interrupt
)

REM Verificar se a escolha está fora do intervalo
if %choice% lss 0 (
	echo.
	echo Opção inválida. Introduz uma opção válida.
    goto :packChoice
)

if %choice% gtr %i% (
	echo.
	echo Opção inválida. Introduz uma opção válida.
    goto :packChoice
)

REM Define o nome do pacote escolhido
set "packName=!packList[%choice%]!"
echo.
echo =========================================================
echo.
if %i% gtr 0 (
	set "optionName=!packList[%choice%]:~17!"
	if "!packList[%choice%]:~14,1!"=="" (
		set "optionName=%packDefaultName%"
	)
	echo O pacote selecionado foi: !optionName!
	echo.
)

:loadPackVariables
REM Variáveis necessárias para a configuração (específicas ao pacote escolhido)
set "neededConfigNames=#fileName#baseUpLevels#expectedFiles#expectedDirs#filesForRemoval#trLicenseFileName"
set "existingConfigNames="

REM Constrói o caminho completo do ficheiro e armazena-o numa variável temporária
set "packInputFile=!packName!\%inputFile%"

REM Lê o ficheiro linha por linha
REM echo !packName!\%inputFile%
for /f "tokens=1,* delims= " %%a in ('type "!packInputFile!"') do (
    set "varName=%%a"
    set "varValue=%%b"
	
    REM Adiciona o nome da variável encontrada à lista de configurações existentes
    set "existingConfigNames=!existingConfigNames!#%%a"
	
    REM echo !varName! é !varValue!

    REM Define a variável com o valor
    set "!varName!=!varValue!"
)

if not "%existingConfigNames%"=="%neededConfigNames%" (
	echo =========================================================
	echo.
	echo Não é possível continuar com a instalação.
	echo Parece que o pacote está corrompido.
	echo.
	echo Experimenta consultar a Ajuda para uma instalação manual.
	echo.
	echo Para uma solução rápida, contacta o 100Nome pelo Discord em:
	echo https://discord.gg/Xv7ax2VkEp
	echo.
	echo Prime qualquer tecla para terminar a instalação.
	pause >nul
	goto :interrupt
)

:search
REM Inicializar a variável para saber se o diretório foi encontrado
set "foundDir=0"
echo Procurar automaticamente a pasta de instalação do jogo?
echo.
echo [S] para sim
echo Outra Letra para sair
echo.
set /p "choice=Introduzir letra e premir Enter > "
if /i "!choice!"=="S" goto :searchUnits
goto :interrupt

:searchUnits
REM Procurar o ficheiro em todas as unidades
for %%D in (!dirsToSearch!) do (
	echo.
	echo =========================================================
	echo.
    echo O diretório de !gameName! será procurado numa nova unidade.
    call :searchDir "%%~D:\"    
)

if "!foundDir!"=="0" (
    echo.
	echo =========================================================
	echo.
    echo Jogo não encontrado em nenhuma unidade.
    goto :error
)

:searchDir
set "dirToSearch=%~1"
if "!searchedDirs!" neq "" (
    if "!searchedDirs!" neq "!searchedDirs:!dirToSearch!;=!" goto :noMoreDisks
)

echo.
echo A procurar na unidade !dirToSearch!...
echo.
echo Não feches esta janela.
for /f "delims=" %%a in ('dir /b /a-d /s "!dirToSearch!%fileName%" 2^>nul') do (
    set "foundExeDir=%%~dpa"
	REM echo upLev: !baseUpLevels!

	REM Inicializa baseDir com o caminho inicial
	set "baseDir=!foundExeDir!"

	REM Remove a barra final do caminho se existir
	if "!baseDir:~-1!"=="\" set "baseDir=!baseDir:~0,-1!"

	REM Ciclo para subir o número especificado de níveis
	for /L %%i in (1,1,!baseUpLevels!) do (
		for %%j in ("!baseDir!\..\") do set "baseDir=%%~fj"
	)
	REM Adiciona a barra final para poder combinar com subpastas
	set "baseDir=!baseDir!\"
	echo.
	REM echo foundExeDir: !foundExeDir!
	REM echo baseDir: !baseDir!
	
	echo.
	echo =========================================================
	echo.
	echo Diretório encontrado:
	echo !baseDir!
	echo.
	echo O instalador tentará encontrar o jogo neste diretório...
	echo.
    set "foundDir=1"
	
	for %%F in (!expectedFiles!) do (
		echo Ficheiro esperado: %%~F
		if not exist "!baseDir!%%~F" (
			echo    Não foi encontrado.
			set "foundDir=0"
		) else echo    Encontrado.
	)
	
	for %%D in (!expectedDirs!) do (
		echo Subdiretório esperado: %%~D
		if not exist "!baseDir!%%~D" (
			echo    Não foi encontrado.
			set "foundDir=0"
		) else echo    Encontrado.
	)

    set "searchedDirs=!searchedDirs!;!dirToSearch!"
    if !foundDir! equ 0 (
		echo.
		echo Nem todos os ficheiros/subdiretórios
		echo esperados foram encontrados neste diretório.
		echo.
		echo Jogo não encontrado neste diretório.
	) else (
		set "exeDir=!foundExeDir!"
		set "gameDir=!baseDir!"
		echo.
		echo =========================================================
		echo.
		echo Jogo encontrado em:
		echo !gameDir!
		echo.
		echo Instalar neste diretório?
		echo.
		echo [S] para sim
		echo [N] para continuar pesquisa
		echo Outra Letra para sair
		echo.
		set /p "choice=Introduzir letra e premir Enter > "
		if /i "!choice!"=="S" goto :install
		if /i "!choice!"=="N" (
			echo.
			echo A pesquisa vai continuar...
		) else (
			goto :interrupt
		)
	)
)
echo.
echo Não há mais diretórios a procurar nesta unidade.
goto :eof

:noMoreDisks
echo.
echo =========================================================
echo.
echo Não há mais unidades de disco onde procurar.
echo.
echo Prime qualquer tecla para avançar.
echo.
pause >nul
echo =========================================================

:notfound
echo.
echo O diretório do jogo !gameName! não foi encontrado.
echo Certifica-te de que o jogo está instalado e tenta de novo.
goto :error

:install
echo.
echo A tradução será instalada no diretório:
echo !gameDir!
set "found=0"
REM Verificar se cópia de segurança existe
set "backupPath=!gameDir!!backupPath!"
for /d %%D in ("%backupPath%*") do (
    if exist "%%D" (
        set "found=1"
        REM echo Pasta encontrada: %%D
    )
)
if "%found%"=="0" (
	goto :backupStart
)

echo.
echo =========================================================
echo.
echo Foi encontrada uma cópia de segurança anterior.
echo Parece que a tradução já foi instalada antes.
echo.
echo "Continuar" instalará sem criar uma nova cópia de segurança.
echo Ou então podes "Continuar com Nova Cópia de Segurança" do conteúdo atual.
echo Podes ainda ver que cópias existem e eliminar as suas pastas manualmente.

:backupoption
echo.
echo [C] para Continuar
echo [CS] para Continuar com Nova Cópia de Segurança
echo [V] para Ver Cópias de Segurança Existentes
echo Outra Letra para sair
echo.
set /p "choice=Introduzir letra e premir Enter > "
if /i "!choice!"=="CS" (
	echo.
	echo O programa vai continuar...
	echo.
) else (
	if /i "!choice!"=="V" (
		echo.
		echo.
		start "" "%gameDir%%spContentFolder%"
		goto :backupoption
	)
	if /i "!choice!"=="C" (
		set "performBackup=0"
		echo.
		echo O programa vai continuar...
		echo.
		for %%F in (!filesForRemoval!) do (
			REM Definir ficheiro possível para remoção
			set "targetFile=!gameDir!%%~F"
			
			REM Caso exista ficheiro a remover,
			REM terá que ser feita uma cópia de segurança desse ficheiro,
			REM ou seja, parcial
			REM performBackup é 0, por isso o programa sabe que deve saltar
			REM a cópia de segurança do resto
			if exist "!targetFile!" (
				goto :backupStart
			)
		)
		goto :copyFiles
	)
	REM Outra letra - sair
	goto :interrupt
)

:backupStart
REM Timestamp - Obtém a data e hora no formato AAAAMMDD_HHMM
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do (
    set datetime=%%i
)
set "formDatetime=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%_%datetime:~8,2%%datetime:~10,2%%datetime:~12,2%"

:createBackupFolder
set /a index=1

set "dirName=!backupPath!_%formDatetime%"

if exist "!dirName!" (
	REM O diretório "!dirName!" já existe.
	set /a index+=1
	set "dirName=!dirName!_%index%"
	goto :createBackupFolder
) else (
	set "backupPath=!dirName!"
	
	REM Se estiver indicado para não guardar cópia de segurança,
	REM apenas será feita uma cópia parcial dos ficheiros obrigatórios
	if !performBackup! equ 0 (
		set "backupPath=!dirName!!partBackupEnding!"
	)
	
	mkdir "!backupPath!"
)

:backup
echo.
echo =========================================================
echo.
if !performBackup! equ 0 (
	echo Alguns ficheiros a remover serão salvaguardados em:
	echo !backupPath!
	goto :removeAndBackup
)

REM Antes de copiar novos ficheiros para o diretório do jogo, salvaguardar os ficheiros existentes para recuperação posterior
echo Será feita uma cópia de segurança dos ficheiros em:
echo !backupPath!
set "searchPath=%~dp0!packName!"
for /r "%searchPath%" %%F in (*) do (
    set "sourceFile=%%F"
    REM echo sf %%F
    REM echo pn !packName!
    REM Obter o caminho relativo a partir de %~dp0
    set "fileRelativePath=%%F"
    REM echo frp !fileRelativePath!
    
    REM Remover o caminho até à pasta do pacote
    set "fileRelativePath=!fileRelativePath:%~dp0=!"
    set "fileRelativePath=!fileRelativePath:%packName%\=!"
    
    REM echo frp2 !fileRelativePath!

    REM Criar o caminho de destino e backup
    set "targetFile=!gameDir!!fileRelativePath!"
    REM echo tf !targetFile!
    set "backupFile=!backupPath!\!fileRelativePath!"
    REM echo bf !backupFile!
    
    if exist "!targetFile!" (
        REM Criar a estrutura de diretórios no backup
        for %%D in ("!backupFile!") do if not exist "%%~dpD" mkdir "%%~dpD"
		
		echo ⠀
		echo Ficheiro a salvaguardar: !fileRelativePath!
		
		if exist "!backupFile!" (
			echo ⠀
			echo O ficheiro de cópia de segurança já existe. Nenhuma ação tomada.
			echo ⠀
		) else (
			REM Move o ficheiro apenas se não houver nenhum com o mesmo nome no destino
			move "!targetFile!" "!backupFile!"
			if errorlevel 1 (
				echo Erro ao mover o ficheiro: !targetFile!
			) else (
				echo Cópia de segurança guardada em:
				echo !backupFile!
			)
			REM Ficheiro movido de !targetFile! para !backupFile!
		)
    )
)
:removeAndBackup
if not "!filesForRemoval!"=="" (
	echo.
	echo Serão removidos alguns ficheiros e salvaguardados...
)
REM Remover ficheiros indicados
for %%F in (!filesForRemoval!) do (
    REM Obter o caminho relativo a partir de %~dp0
    set "fileRelativePath=%%~F"

    REM Criar o caminho de destino e backup
    set "targetFile=!gameDir!!fileRelativePath!"
    set "backupFile=!backupPath!\!fileRelativePath!"
	
	REM echo info copia seg
	REM echo !targetFile!
	REM echo !backupFile!
	REM echo !fileRelativePath!
	REM echo fim info
	REM echo.
    
    if exist "!targetFile!" (
        REM Criar a estrutura de diretórios no backup
        for %%D in ("!backupFile!") do if not exist "%%~dpD" mkdir "%%~dpD"
		
		echo ⠀
		echo Ficheiro a remover e salvaguardar: !fileRelativePath!
		
		if exist "!backupFile!" (
			echo ⠀
			echo O ficheiro de cópia de segurança já existe. Nenhuma ação tomada.
			echo ⠀
		) else (
			REM Move o ficheiro apenas se não houver nenhum com o mesmo nome no destino
			move "!targetFile!" "!backupFile!"
			echo Cópia de segurança guardada em:
			echo !backupFile!
			REM Ficheiro movido de !targetFile! para !backupFile!
		)
    )
)

:copyFiles
REM Copiar todos os ficheiros e pastas do diretório atual para o diretório do jogo
echo.
echo =========================================================
echo.
echo O pacote de tradução será instalado no diretório do jogo...
echo.
echo Os ficheiros de:
echo %~dp0!packName!
echo Serão copiados para:
echo !gameDir!
echo.
xcopy /e /i /y "%~dp0!packName!\*" "!gameDir!"
REM robocopy "%~dp0!packName!" "!gameDir!" /e /copyall /r:3 /w:5 /mt
set "scriptFileName=%~nx0"

echo.
echo Na ausência de erros em cima,
echo a instalação foi concluída com sucesso.
set "installed=1"
goto :end

:error
echo.
echo =========================================================
echo.
echo A instalação não pôde ser concluída :'(
goto :end

:interrupt
echo.
echo =========================================================
echo.
echo Instalação interrompida por ordem do utilizador.
goto :end

:end
echo.
echo.
echo FIM DO PROGRAMA

:end2
echo.
echo.
echo.
echo [A] para abrir Ajuda
if not "!packName!"=="" (
	echo [N] para Notas da Tradução
	echo [L] para Licença da Tradução
)
if %installed% equ 1 (
	echo [P] para abrir Pasta do Jogo
	echo [J] para Iniciar Jogo
)
echo.
echo // [T] para Terminar Instalação //
echo.
set /p "choice=Introduzir letra e premir Enter > "
if /i "!choice!"=="A" (
	start "" "%helpFileName%"
	goto :end2
)

if not "!packName!"=="" (
	REM echo packname = !packName!
	if /i "!choice!"=="N" (
		start "" "!packName!\!spContentFolder!\%trNotesFileName%"
		goto :end2
	)
	if /i "!choice!"=="L" (
		start "" "!packName!\!spContentFolder!\%trLicenseFileName%"
		goto :end2
	)
)

if %installed% equ 1 (
	if /i "!choice!"=="P" (
		start "" "%gameDir%"
		goto :end2
	)
	if /i "!choice!"=="J" (
		cd /d "%exeDir%"
		start "" "%fileName%"
		goto :end2
	)
)

if %installed% equ 1 (
	start "" https://100nome.blogs.sapo.pt/!urlEnd!#instalado
)

EXIT 0

:configs
cls
echo.
echo  ██╗ ██████╗  ██████╗ ███╗   ██╗ ██████╗ ███╗   ███╗███████╗
ping -n 1 127.0.0.1 >nul
echo ███║██╔═████╗██╔═████╗████╗  ██║██╔═══██╗████╗ ████║██╔════╝
ping -n 1 127.0.0.1 >nul
echo ╚██║██║██╔██║██║██╔██║██╔██╗ ██║██║   ██║██╔████╔██║█████╗  
ping -n 1 127.0.0.1 >nul
echo  ██║████╔╝██║████╔╝██║██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══╝  
ping -n 1 127.0.0.1 >nul
echo  ██║╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝██║ ╚═╝ ██║███████╗
ping -n 1 127.0.0.1 >nul
echo  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
ping -n 1 127.0.0.1 >nul
echo.
echo =========================================================
echo                       CONFIGURAÇÕES
echo              [V] para voltar ao Menu Inicial
echo =========================================================
echo.
echo - BUSCA AUTOMÁTICA PELO JOGO
echo.
echo [UD] para Alterar unidades de disco na busca e a sua ordem
echo      / A busca automática segue a ordem indicada. /
echo.
echo [ Ordem atual: "!dirsToSearch!" ]
echo.
echo.
echo [LE] para Definir a localização do executável do jogo
echo      / Isto desativa a busca automática. /
echo.
if not "!exeDir!"=="" (
	echo [ Localização definida: "!exeDir!" ]
) else (
    echo [ A busca automática está ativada. ]
)
echo.
echo.
set /p "choice=Introduzir opção e premir Enter > "
if /i "!choice!"=="UD" (
	goto :config-UD
)
if /i "!choice!"=="LE" (
	goto :config-LE
)
if /i "!choice!"=="V" (
	cls
	goto :main-menu-intro
)
goto :configs

:config-UD
echo.
echo =========================================================
echo.
echo [ Ordem atual: "!dirsToSearch!" ]
echo.
echo / Como introduzir: sem aspas; elementos separados por espaço. /
echo / Deixar vazio para manter igual. /
echo.
set /p "choice=Introduzir nova ordem e premir Enter > "
echo.
if not "%choice%"=="ud" (
	set "dirsToSearch=%choice%"
	echo [ Nova ordem: "!dirsToSearch!" ]
) else (
    echo [ A ordem não foi alterada. ]
)
goto :end-config

:config-LE
echo.
echo =========================================================
echo.
if not "!exeDir!"=="" (
	echo [ Localização definida: "!exeDir!" ]
) else (
    echo [ A busca automática está ativada. ]
)
echo.
echo / Como introduzir: localização do executável completa, sem aspas. /
echo / Deixar vazio para ativar a busca automática. /
echo.
set /p "choice=Introduzir localização e premir Enter > "
echo.
if not "%choice%"=="le" (
	set "exeDir=%choice%"
	echo [ Localização definida: "!exeDir!" ]
) else (
	set "exeDir="
    echo [ A busca automática está ativada. ]
)
goto :end-config

:end-config
echo.
echo Prime qualquer tecla para avançar.
echo.
pause >nul
goto :configs

:license
cls
echo                     GNU GENERAL PUBLIC LICENSE
echo                        Version 3, 29 June 2007
echo.
echo  Copyright (C) 2007 Free Software Foundation, Inc. https://fsf.org/
echo  Everyone is permitted to copy and distribute verbatim copies
echo  of this license document, but changing it is not allowed.
echo.
echo                             Preamble
echo.
echo   The GNU General Public License is a free, copyleft license for
echo software and other kinds of works.
echo.
echo   The licenses for most software and other practical works are designed
echo to take away your freedom to share and change the works.  By contrast,
echo the GNU General Public License is intended to guarantee your freedom to
echo share and change all versions of a program--to make sure it remains free
echo software for all its users.  We, the Free Software Foundation, use the
echo GNU General Public License for most of our software; it applies also to
echo any other work released this way by its authors.  You can apply it to
echo your programs, too.
echo.
echo   When we speak of free software, we are referring to freedom, not
echo price.  Our General Public Licenses are designed to make sure that you
echo have the freedom to distribute copies of free software (and charge for
echo them if you wish), that you receive source code or can get it if you
echo want it, that you can change the software or use pieces of it in new
echo free programs, and that you know you can do these things.
echo.
echo   To protect your rights, we need to prevent others from denying you
echo these rights or asking you to surrender the rights.  Therefore, you have
echo certain responsibilities if you distribute copies of the software, or if
echo you modify it: responsibilities to respect the freedom of others.
echo.
echo   For example, if you distribute copies of such a program, whether
echo gratis or for a fee, you must pass on to the recipients the same
echo freedoms that you received.  You must make sure that they, too, receive
echo or can get the source code.  And you must show them these terms so they
echo know their rights.
echo.
echo   Developers that use the GNU GPL protect your rights with two steps:
echo (1) assert copyright on the software, and (2) offer you this License
echo giving you legal permission to copy, distribute and/or modify it.
echo.
echo   For the developers' and authors' protection, the GPL clearly explains
echo that there is no warranty for this free software.  For both users' and
echo authors' sake, the GPL requires that modified versions be marked as
echo changed, so that their problems will not be attributed erroneously to
echo authors of previous versions.
echo.
echo   Some devices are designed to deny users access to install or run
echo modified versions of the software inside them, although the manufacturer
echo can do so.  This is fundamentally incompatible with the aim of
echo protecting users' freedom to change the software.  The systematic
echo pattern of such abuse occurs in the area of products for individuals to
echo use, which is precisely where it is most unacceptable.  Therefore, we
echo have designed this version of the GPL to prohibit the practice for those
echo products.  If such problems arise substantially in other domains, we
echo stand ready to extend this provision to those domains in future versions
echo of the GPL, as needed to protect the freedom of users.
echo.
echo   Finally, every program is threatened constantly by software patents.
echo States should not allow patents to restrict development and use of
echo software on general-purpose computers, but in those that do, we wish to
echo avoid the special danger that patents applied to a free program could
echo make it effectively proprietary.  To prevent this, the GPL assures that
echo patents cannot be used to render the program non-free.
echo.
echo   The precise terms and conditions for copying, distribution and
echo modification follow.
echo.
echo                        TERMS AND CONDITIONS
echo.
echo   0. Definitions.
echo.
echo   "This License" refers to version 3 of the GNU General Public License.
echo.
echo   "Copyright" also means copyright-like laws that apply to other kinds of
echo works, such as semiconductor masks.
echo.
echo   "The Program" refers to any copyrightable work licensed under this
echo License.  Each licensee is addressed as "you".  "Licensees" and
echo "recipients" may be individuals or organizations.
echo.
echo   To "modify" a work means to copy from or adapt all or part of the work
echo in a fashion requiring copyright permission, other than the making of an
echo exact copy.  The resulting work is called a "modified version" of the
echo earlier work or a work "based on" the earlier work.
echo.
echo   A "covered work" means either the unmodified Program or a work based
echo on the Program.
echo.
echo   To "propagate" a work means to do anything with it that, without
echo permission, would make you directly or secondarily liable for
echo infringement under applicable copyright law, except executing it on a
echo computer or modifying a private copy.  Propagation includes copying,
echo distribution (with or without modification), making available to the
echo public, and in some countries other activities as well.
echo.
echo   To "convey" a work means any kind of propagation that enables other
echo parties to make or receive copies.  Mere interaction with a user through
echo a computer network, with no transfer of a copy, is not conveying.
echo.
echo   An interactive user interface displays "Appropriate Legal Notices"
echo to the extent that it includes a convenient and prominently visible
echo feature that (1) displays an appropriate copyright notice, and (2)
echo tells the user that there is no warranty for the work (except to the
echo extent that warranties are provided), that licensees may convey the
echo work under this License, and how to view a copy of this License.  If
echo the interface presents a list of user commands or options, such as a
echo menu, a prominent item in the list meets this criterion.
echo.
echo   1. Source Code.
echo.
echo   The "source code" for a work means the preferred form of the work
echo for making modifications to it.  "Object code" means any non-source
echo form of a work.
echo.
echo   A "Standard Interface" means an interface that either is an official
echo standard defined by a recognized standards body, or, in the case of
echo interfaces specified for a particular programming language, one that
echo is widely used among developers working in that language.
echo.
echo   The "System Libraries" of an executable work include anything, other
echo than the work as a whole, that (a) is included in the normal form of
echo packaging a Major Component, but which is not part of that Major
echo Component, and (b) serves only to enable use of the work with that
echo Major Component, or to implement a Standard Interface for which an
echo implementation is available to the public in source code form.  A
echo "Major Component", in this context, means a major essential component
echo (kernel, window system, and so on) of the specific operating system
echo (if any) on which the executable work runs, or a compiler used to
echo produce the work, or an object code interpreter used to run it.
echo.
echo   The "Corresponding Source" for a work in object code form means all
echo the source code needed to generate, install, and (for an executable
echo work) run the object code and to modify the work, including scripts to
echo control those activities.  However, it does not include the work's
echo System Libraries, or general-purpose tools or generally available free
echo programs which are used unmodified in performing those activities but
echo which are not part of the work.  For example, Corresponding Source
echo includes interface definition files associated with source files for
echo the work, and the source code for shared libraries and dynamically
echo linked subprograms that the work is specifically designed to require,
echo such as by intimate data communication or control flow between those
echo subprograms and other parts of the work.
echo.
echo   The Corresponding Source need not include anything that users
echo can regenerate automatically from other parts of the Corresponding
echo Source.
echo.
echo   The Corresponding Source for a work in source code form is that
echo same work.
echo.
echo   2. Basic Permissions.
echo.
echo   All rights granted under this License are granted for the term of
echo copyright on the Program, and are irrevocable provided the stated
echo conditions are met.  This License explicitly affirms your unlimited
echo permission to run the unmodified Program.  The output from running a
echo covered work is covered by this License only if the output, given its
echo content, constitutes a covered work.  This License acknowledges your
echo rights of fair use or other equivalent, as provided by copyright law.
echo.
echo   You may make, run and propagate covered works that you do not
echo convey, without conditions so long as your license otherwise remains
echo in force.  You may convey covered works to others for the sole purpose
echo of having them make modifications exclusively for you, or provide you
echo with facilities for running those works, provided that you comply with
echo the terms of this License in conveying all material for which you do
echo not control copyright.  Those thus making or running the covered works
echo for you must do so exclusively on your behalf, under your direction
echo and control, on terms that prohibit them from making any copies of
echo your copyrighted material outside their relationship with you.
echo.
echo   Conveying under any other circumstances is permitted solely under
echo the conditions stated below.  Sublicensing is not allowed; section 10
echo makes it unnecessary.
echo.
echo   3. Protecting Users' Legal Rights From Anti-Circumvention Law.
echo.
echo   No covered work shall be deemed part of an effective technological
echo measure under any applicable law fulfilling obligations under article
echo 11 of the WIPO copyright treaty adopted on 20 December 1996, or
echo similar laws prohibiting or restricting circumvention of such
echo measures.
echo.
echo   When you convey a covered work, you waive any legal power to forbid
echo circumvention of technological measures to the extent such circumvention
echo is effected by exercising rights under this License with respect to
echo the covered work, and you disclaim any intention to limit operation or
echo modification of the work as a means of enforcing, against the work's
echo users, your or third parties' legal rights to forbid circumvention of
echo technological measures.
echo.
echo   4. Conveying Verbatim Copies.
echo.
echo   You may convey verbatim copies of the Program's source code as you
echo receive it, in any medium, provided that you conspicuously and
echo appropriately publish on each copy an appropriate copyright notice;
echo keep intact all notices stating that this License and any
echo non-permissive terms added in accord with section 7 apply to the code;
echo keep intact all notices of the absence of any warranty; and give all
echo recipients a copy of this License along with the Program.
echo.
echo   You may charge any price or no price for each copy that you convey,
echo and you may offer support or warranty protection for a fee.
echo.
echo   5. Conveying Modified Source Versions.
echo.
echo   You may convey a work based on the Program, or the modifications to
echo produce it from the Program, in the form of source code under the
echo terms of section 4, provided that you also meet all of these conditions:
echo.
echo     a) The work must carry prominent notices stating that you modified
echo     it, and giving a relevant date.
echo.
echo     b) The work must carry prominent notices stating that it is
echo     released under this License and any conditions added under section
echo     7.  This requirement modifies the requirement in section 4 to
echo     "keep intact all notices".
echo.
echo     c) You must license the entire work, as a whole, under this
echo     License to anyone who comes into possession of a copy.  This
echo     License will therefore apply, along with any applicable section 7
echo     additional terms, to the whole of the work, and all its parts,
echo     regardless of how they are packaged.  This License gives no
echo     permission to license the work in any other way, but it does not
echo     invalidate such permission if you have separately received it.
echo.
echo     d) If the work has interactive user interfaces, each must display
echo     Appropriate Legal Notices; however, if the Program has interactive
echo     interfaces that do not display Appropriate Legal Notices, your
echo     work need not make them do so.
echo.
echo   A compilation of a covered work with other separate and independent
echo works, which are not by their nature extensions of the covered work,
echo and which are not combined with it such as to form a larger program,
echo in or on a volume of a storage or distribution medium, is called an
echo "aggregate" if the compilation and its resulting copyright are not
echo used to limit the access or legal rights of the compilation's users
echo beyond what the individual works permit.  Inclusion of a covered work
echo in an aggregate does not cause this License to apply to the other
echo parts of the aggregate.
echo.
echo   6. Conveying Non-Source Forms.
echo.
echo   You may convey a covered work in object code form under the terms
echo of sections 4 and 5, provided that you also convey the
echo machine-readable Corresponding Source under the terms of this License,
echo in one of these ways:
echo.
echo     a) Convey the object code in, or embodied in, a physical product
echo     (including a physical distribution medium), accompanied by the
echo     Corresponding Source fixed on a durable physical medium
echo     customarily used for software interchange.
echo.
echo     b) Convey the object code in, or embodied in, a physical product
echo     (including a physical distribution medium), accompanied by a
echo     written offer, valid for at least three years and valid for as
echo     long as you offer spare parts or customer support for that product
echo     model, to give anyone who possesses the object code either (1) a
echo     copy of the Corresponding Source for all the software in the
echo     product that is covered by this License, on a durable physical
echo     medium customarily used for software interchange, for a price no
echo     more than your reasonable cost of physically performing this
echo     conveying of source, or (2) access to copy the
echo     Corresponding Source from a network server at no charge.
echo.
echo     c) Convey individual copies of the object code with a copy of the
echo     written offer to provide the Corresponding Source.  This
echo     alternative is allowed only occasionally and noncommercially, and
echo     only if you received the object code with such an offer, in accord
echo     with subsection 6b.
echo.
echo     d) Convey the object code by offering access from a designated
echo     place (gratis or for a charge), and offer equivalent access to the
echo     Corresponding Source in the same way through the same place at no
echo     further charge.  You need not require recipients to copy the
echo     Corresponding Source along with the object code.  If the place to
echo     copy the object code is a network server, the Corresponding Source
echo     may be on a different server (operated by you or a third party)
echo     that supports equivalent copying facilities, provided you maintain
echo     clear directions next to the object code saying where to find the
echo     Corresponding Source.  Regardless of what server hosts the
echo     Corresponding Source, you remain obligated to ensure that it is
echo     available for as long as needed to satisfy these requirements.
echo.
echo     e) Convey the object code using peer-to-peer transmission, provided
echo     you inform other peers where the object code and Corresponding
echo     Source of the work are being offered to the general public at no
echo     charge under subsection 6d.
echo.
echo   A separable portion of the object code, whose source code is excluded
echo from the Corresponding Source as a System Library, need not be
echo included in conveying the object code work.
echo.
echo   A "User Product" is either (1) a "consumer product", which means any
echo tangible personal property which is normally used for personal, family,
echo or household purposes, or (2) anything designed or sold for incorporation
echo into a dwelling.  In determining whether a product is a consumer product,
echo doubtful cases shall be resolved in favor of coverage.  For a particular
echo product received by a particular user, "normally used" refers to a
echo typical or common use of that class of product, regardless of the status
echo of the particular user or of the way in which the particular user
echo actually uses, or expects or is expected to use, the product.  A product
echo is a consumer product regardless of whether the product has substantial
echo commercial, industrial or non-consumer uses, unless such uses represent
echo the only significant mode of use of the product.
echo.
echo   "Installation Information" for a User Product means any methods,
echo procedures, authorization keys, or other information required to install
echo and execute modified versions of a covered work in that User Product from
echo a modified version of its Corresponding Source.  The information must
echo suffice to ensure that the continued functioning of the modified object
echo code is in no case prevented or interfered with solely because
echo modification has been made.
echo.
echo   If you convey an object code work under this section in, or with, or
echo specifically for use in, a User Product, and the conveying occurs as
echo part of a transaction in which the right of possession and use of the
echo User Product is transferred to the recipient in perpetuity or for a
echo fixed term (regardless of how the transaction is characterized), the
echo Corresponding Source conveyed under this section must be accompanied
echo by the Installation Information.  But this requirement does not apply
echo if neither you nor any third party retains the ability to install
echo modified object code on the User Product (for example, the work has
echo been installed in ROM).
echo.
echo   The requirement to provide Installation Information does not include a
echo requirement to continue to provide support service, warranty, or updates
echo for a work that has been modified or installed by the recipient, or for
echo the User Product in which it has been modified or installed.  Access to a
echo network may be denied when the modification itself materially and
echo adversely affects the operation of the network or violates the rules and
echo protocols for communication across the network.
echo.
echo   Corresponding Source conveyed, and Installation Information provided,
echo in accord with this section must be in a format that is publicly
echo documented (and with an implementation available to the public in
echo source code form), and must require no special password or key for
echo unpacking, reading or copying.
echo.
echo   7. Additional Terms.
echo.
echo   "Additional permissions" are terms that supplement the terms of this
echo License by making exceptions from one or more of its conditions.
echo Additional permissions that are applicable to the entire Program shall
echo be treated as though they were included in this License, to the extent
echo that they are valid under applicable law.  If additional permissions
echo apply only to part of the Program, that part may be used separately
echo under those permissions, but the entire Program remains governed by
echo this License without regard to the additional permissions.
echo.
echo   When you convey a copy of a covered work, you may at your option
echo remove any additional permissions from that copy, or from any part of
echo it.  (Additional permissions may be written to require their own
echo removal in certain cases when you modify the work.)  You may place
echo additional permissions on material, added by you to a covered work,
echo for which you have or can give appropriate copyright permission.
echo.
echo   Notwithstanding any other provision of this License, for material you
echo add to a covered work, you may (if authorized by the copyright holders of
echo that material) supplement the terms of this License with terms:
echo.
echo     a) Disclaiming warranty or limiting liability differently from the
echo     terms of sections 15 and 16 of this License; or
echo.
echo     b) Requiring preservation of specified reasonable legal notices or
echo     author attributions in that material or in the Appropriate Legal
echo     Notices displayed by works containing it; or
echo.
echo     c) Prohibiting misrepresentation of the origin of that material, or
echo     requiring that modified versions of such material be marked in
echo     reasonable ways as different from the original version; or
echo.
echo     d) Limiting the use for publicity purposes of names of licensors or
echo     authors of the material; or
echo.
echo     e) Declining to grant rights under trademark law for use of some
echo     trade names, trademarks, or service marks; or
echo.
echo     f) Requiring indemnification of licensors and authors of that
echo     material by anyone who conveys the material (or modified versions of
echo     it) with contractual assumptions of liability to the recipient, for
echo     any liability that these contractual assumptions directly impose on
echo     those licensors and authors.
echo.
echo   All other non-permissive additional terms are considered "further
echo restrictions" within the meaning of section 10.  If the Program as you
echo received it, or any part of it, contains a notice stating that it is
echo governed by this License along with a term that is a further
echo restriction, you may remove that term.  If a license document contains
echo a further restriction but permits relicensing or conveying under this
echo License, you may add to a covered work material governed by the terms
echo of that license document, provided that the further restriction does
echo not survive such relicensing or conveying.
echo.
echo   If you add terms to a covered work in accord with this section, you
echo must place, in the relevant source files, a statement of the
echo additional terms that apply to those files, or a notice indicating
echo where to find the applicable terms.
echo.
echo   Additional terms, permissive or non-permissive, may be stated in the
echo form of a separately written license, or stated as exceptions;
echo the above requirements apply either way.
echo.
echo   8. Termination.
echo.
echo   You may not propagate or modify a covered work except as expressly
echo provided under this License.  Any attempt otherwise to propagate or
echo modify it is void, and will automatically terminate your rights under
echo this License (including any patent licenses granted under the third
echo paragraph of section 11).
echo.
echo   However, if you cease all violation of this License, then your
echo license from a particular copyright holder is reinstated (a)
echo provisionally, unless and until the copyright holder explicitly and
echo finally terminates your license, and (b) permanently, if the copyright
echo holder fails to notify you of the violation by some reasonable means
echo prior to 60 days after the cessation.
echo.
echo   Moreover, your license from a particular copyright holder is
echo reinstated permanently if the copyright holder notifies you of the
echo violation by some reasonable means, this is the first time you have
echo received notice of violation of this License (for any work) from that
echo copyright holder, and you cure the violation prior to 30 days after
echo your receipt of the notice.
echo.
echo   Termination of your rights under this section does not terminate the
echo licenses of parties who have received copies or rights from you under
echo this License.  If your rights have been terminated and not permanently
echo reinstated, you do not qualify to receive new licenses for the same
echo material under section 10.
echo.
echo   9. Acceptance Not Required for Having Copies.
echo.
echo   You are not required to accept this License in order to receive or
echo run a copy of the Program.  Ancillary propagation of a covered work
echo occurring solely as a consequence of using peer-to-peer transmission
echo to receive a copy likewise does not require acceptance.  However,
echo nothing other than this License grants you permission to propagate or
echo modify any covered work.  These actions infringe copyright if you do
echo not accept this License.  Therefore, by modifying or propagating a
echo covered work, you indicate your acceptance of this License to do so.
echo.
echo   10. Automatic Licensing of Downstream Recipients.
echo.
echo   Each time you convey a covered work, the recipient automatically
echo receives a license from the original licensors, to run, modify and
echo propagate that work, subject to this License.  You are not responsible
echo for enforcing compliance by third parties with this License.
echo.
echo   An "entity transaction" is a transaction transferring control of an
echo organization, or substantially all assets of one, or subdividing an
echo organization, or merging organizations.  If propagation of a covered
echo work results from an entity transaction, each party to that
echo transaction who receives a copy of the work also receives whatever
echo licenses to the work the party's predecessor in interest had or could
echo give under the previous paragraph, plus a right to possession of the
echo Corresponding Source of the work from the predecessor in interest, if
echo the predecessor has it or can get it with reasonable efforts.
echo.
echo   You may not impose any further restrictions on the exercise of the
echo rights granted or affirmed under this License.  For example, you may
echo not impose a license fee, royalty, or other charge for exercise of
echo rights granted under this License, and you may not initiate litigation
echo (including a cross-claim or counterclaim in a lawsuit) alleging that
echo any patent claim is infringed by making, using, selling, offering for
echo sale, or importing the Program or any portion of it.
echo.
echo   11. Patents.
echo.
echo   A "contributor" is a copyright holder who authorizes use under this
echo License of the Program or a work on which the Program is based.  The
echo work thus licensed is called the contributor's "contributor version".
echo.
echo   A contributor's "essential patent claims" are all patent claims
echo owned or controlled by the contributor, whether already acquired or
echo hereafter acquired, that would be infringed by some manner, permitted
echo by this License, of making, using, or selling its contributor version,
echo but do not include claims that would be infringed only as a
echo consequence of further modification of the contributor version.  For
echo purposes of this definition, "control" includes the right to grant
echo patent sublicenses in a manner consistent with the requirements of
echo this License.
echo.
echo   Each contributor grants you a non-exclusive, worldwide, royalty-free
echo patent license under the contributor's essential patent claims, to
echo make, use, sell, offer for sale, import and otherwise run, modify and
echo propagate the contents of its contributor version.
echo.
echo   In the following three paragraphs, a "patent license" is any express
echo agreement or commitment, however denominated, not to enforce a patent
echo (such as an express permission to practice a patent or covenant not to
echo sue for patent infringement).  To "grant" such a patent license to a
echo party means to make such an agreement or commitment not to enforce a
echo patent against the party.
echo.
echo   If you convey a covered work, knowingly relying on a patent license,
echo and the Corresponding Source of the work is not available for anyone
echo to copy, free of charge and under the terms of this License, through a
echo publicly available network server or other readily accessible means,
echo then you must either (1) cause the Corresponding Source to be so
echo available, or (2) arrange to deprive yourself of the benefit of the
echo patent license for this particular work, or (3) arrange, in a manner
echo consistent with the requirements of this License, to extend the patent
echo license to downstream recipients.  "Knowingly relying" means you have
echo actual knowledge that, but for the patent license, your conveying the
echo covered work in a country, or your recipient's use of the covered work
echo in a country, would infringe one or more identifiable patents in that
echo country that you have reason to believe are valid.
echo.
echo   If, pursuant to or in connection with a single transaction or
echo arrangement, you convey, or propagate by procuring conveyance of, a
echo covered work, and grant a patent license to some of the parties
echo receiving the covered work authorizing them to use, propagate, modify
echo or convey a specific copy of the covered work, then the patent license
echo you grant is automatically extended to all recipients of the covered
echo work and works based on it.
echo.
echo   A patent license is "discriminatory" if it does not include within
echo the scope of its coverage, prohibits the exercise of, or is
echo conditioned on the non-exercise of one or more of the rights that are
echo specifically granted under this License.  You may not convey a covered
echo work if you are a party to an arrangement with a third party that is
echo in the business of distributing software, under which you make payment
echo to the third party based on the extent of your activity of conveying
echo the work, and under which the third party grants, to any of the
echo parties who would receive the covered work from you, a discriminatory
echo patent license (a) in connection with copies of the covered work
echo conveyed by you (or copies made from those copies), or (b) primarily
echo for and in connection with specific products or compilations that
echo contain the covered work, unless you entered into that arrangement,
echo or that patent license was granted, prior to 28 March 2007.
echo.
echo   Nothing in this License shall be construed as excluding or limiting
echo any implied license or other defenses to infringement that may
echo otherwise be available to you under applicable patent law.
echo.
echo   12. No Surrender of Others' Freedom.
echo.
echo   If conditions are imposed on you (whether by court order, agreement or
echo otherwise) that contradict the conditions of this License, they do not
echo excuse you from the conditions of this License.  If you cannot convey a
echo covered work so as to satisfy simultaneously your obligations under this
echo License and any other pertinent obligations, then as a consequence you may
echo not convey it at all.  For example, if you agree to terms that obligate you
echo to collect a royalty for further conveying from those to whom you convey
echo the Program, the only way you could satisfy both those terms and this
echo License would be to refrain entirely from conveying the Program.
echo.
echo   13. Use with the GNU Affero General Public License.
echo.
echo   Notwithstanding any other provision of this License, you have
echo permission to link or combine any covered work with a work licensed
echo under version 3 of the GNU Affero General Public License into a single
echo combined work, and to convey the resulting work.  The terms of this
echo License will continue to apply to the part which is the covered work,
echo but the special requirements of the GNU Affero General Public License,
echo section 13, concerning interaction through a network will apply to the
echo combination as such.
echo.
echo   14. Revised Versions of this License.
echo.
echo   The Free Software Foundation may publish revised and/or new versions of
echo the GNU General Public License from time to time.  Such new versions will
echo be similar in spirit to the present version, but may differ in detail to
echo address new problems or concerns.
echo.
echo   Each version is given a distinguishing version number.  If the
echo Program specifies that a certain numbered version of the GNU General
echo Public License "or any later version" applies to it, you have the
echo option of following the terms and conditions either of that numbered
echo version or of any later version published by the Free Software
echo Foundation.  If the Program does not specify a version number of the
echo GNU General Public License, you may choose any version ever published
echo by the Free Software Foundation.
echo.
echo   If the Program specifies that a proxy can decide which future
echo versions of the GNU General Public License can be used, that proxy's
echo public statement of acceptance of a version permanently authorizes you
echo to choose that version for the Program.
echo.
echo   Later license versions may give you additional or different
echo permissions.  However, no additional obligations are imposed on any
echo author or copyright holder as a result of your choosing to follow a
echo later version.
echo.
echo   15. Disclaimer of Warranty.
echo.
echo   THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
echo APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
echo HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
echo OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
echo THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
echo PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
echo IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
echo ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
echo.
echo   16. Limitation of Liability.
echo.
echo   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
echo WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
echo THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
echo GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
echo USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
echo DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
echo PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
echo EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
echo SUCH DAMAGES.
echo.
echo   17. Interpretation of Sections 15 and 16.
echo.
echo   If the disclaimer of warranty and limitation of liability provided
echo above cannot be given local legal effect according to their terms,
echo reviewing courts shall apply local law that most closely approximates
echo an absolute waiver of all civil liability in connection with the
echo Program, unless a warranty or assumption of liability accompanies a
echo copy of the Program in return for a fee.
echo.
echo                      END OF TERMS AND CONDITIONS
echo.
echo Podes aceder à versão mais recente do código em:
echo https://github.com/joaofradept/autoinstalador-100Nome/.
echo.
echo Se não conseguires ler a licença acima, podes visualizá-la abrindo o
echo script com um editor de texto ou então consulta a licença online em
echo https://www.gnu.org/licenses/gpl-3.0.html.
echo.
echo Prime qualquer tecla para voltar ao Menu Inicial.
pause >nul
cls
goto :main-menu-intro