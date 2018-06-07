      *================================================================*00000100
       IDENTIFICATION                  DIVISION.                        00000200
      *================================================================*00000300
       PROGRAM-ID. CMCD2NER.                                            00000400
       AUTHOR.     HENRIQUE MANDROTE.                                   00000500
      *================================================================*00000600
      *                    D E D I C      G P T I                      *00000700
      *----------------------------------------------------------------*00000800
      *    SISTEMA.....: CMCD - COBRANCA - CONVIVENCIA E MIGRACAO      *00000900
      *    PROGRAMA....: CMCD2NER                                      *00001000
      *    PROGRAMADOR.: HENRIQUE                                      *00001100
      *    ANALISTA....: CARLOS            - DEDIC GPTI                *00001200
      *    DATA........: 04/2011                                       *00001300
      *----------------------------------------------------------------*00001400
      *    OBJETIVO....: EMITIR RELATORIO COM DADOS DA TABELA CBCAB009 *00001500
      *----------------------------------------------------------------*00001600
      *    ARQUIVOS:                                                   *00001700
      *      DDNAME            I/O                                     *00001800
      *      ARCBCA09           I                                      *00001900
      *      RECBCA09           O                                      *00002000
      *----------------------------------------------------------------*00002100
      *    COPY /INC :                                                 *00002200
      *    CMCDWES1 - AREA EXIBICAO DAS ESTATISTICAS DE PROCESSAMENTO. *00002300
      *----------------------------------------------------------------*00002400
      *    MODULOS.....:                                               *00002500
      *    -------------                                               *00002600
      *    POOL7600 - OBTER DATA E HORA ATUAIS.                        *00002700
      *    CMCD2N0F - EXIBICAO DAS ESTATISTICAS DE PROCESSAMENTO.      *00002800
      *================================================================*00002900
      *                                                                 00003000
      *================================================================*00003100
       ENVIRONMENT                     DIVISION.                        00003200
      *================================================================*00003300
      *                                                                 00003400
      *----------------------------------------------------------------*00003500
       CONFIGURATION                   SECTION.                         00003600
      *----------------------------------------------------------------*00003700
      *                                                                 00003800
       SPECIAL-NAMES.                                                   00003900
           DECIMAL-POINT               IS COMMA.                        00004000
      *                                                                 00004100
      *---------------------------------------------------------------* 00004200
       INPUT-OUTPUT                    SECTION.                         00004300
      *---------------------------------------------------------------* 00004400
      *                                                                 00004500
       FILE-CONTROL.                                                    00004600
                                                                        00004700
           SELECT  ARCBCA09  ASSIGN    TO UT-S-ARCBCA09                 00004800
                   FILE    STATUS      IS WRK-FS-ARCBCA09.              00004900
                                                                        00005000
           SELECT  RECBCA09  ASSIGN    TO UT-S-RECBCA09                 00005100
                   FILE    STATUS      IS WRK-FS-RECBCA09.              00005200
      *                                                                 00005300
      *----------------------------------------------------------------*00005400
       DATA                            DIVISION.                        00005500
      *----------------------------------------------------------------*00005600
      *                                                                 00005700
      *----------------------------------------------------------------*00005800
       FILE                            SECTION.                         00005900
      *----------------------------------------------------------------*00006000
                                                                        00006100
      *----------------------------------------------------------------*00006200
      *    INPUT  :  IMAGEM DA TABELA CBCAB009                         *00006300
      *              ORG. SEQUENCIAL   -   LRECL = 180                 *00006400
      *----------------------------------------------------------------*00006500
                                                                        00006600
       FD  ARCBCA09                                                     00006700
           RECORDING MODE IS F                                          00006800
           LABEL RECORD IS STANDARD                                     00006900
           BLOCK CONTAINS 0 RECORDS.                                    00007000
                                                                        00007100
       01  FD-ARCBCA09                   PIC  X(180).                   00007200
                                                                        00007300
      *----------------------------------------------------------------*00007400
      *    OUTPUT  : ARQUIVO RECBCA09                                   00007500
      *              ORG. SEQUENCIAL   - LRECL = 133                   *00007600
      *----------------------------------------------------------------*00007700
      *                                                                 00007800
       FD  RECBCA09                                                     00007900
           RECORDING MODE IS F                                          00008000
           LABEL RECORD IS STANDARD                                     00008100
           BLOCK CONTAINS 0 RECORDS.                                    00008200
      *                                                                 00008300
       01  FD-RECBCA09                   PIC  X(133).                   00008400
      *                                                                 00008500
      *----------------------------------------------------------------*00008600
       WORKING-STORAGE                 SECTION.                         00008700
      *----------------------------------------------------------------*00008800
      *                                                                 00008900
      *----------------------------------------------------------------*00009000
       77  FILLER                      PIC  X(050)         VALUE        00009100
           '* INICIO DA WORKING STORAGE SECTION *'.                     00009200
      *----------------------------------------------------------------*00009300
      *                                                                 00009400
      *----------------------------------------------------------------*00009500
       77  FILLER                      PIC  X(050)         VALUE        00009600
           '* AREA PARA INDEXADORES *'.                                 00009700
      *----------------------------------------------------------------*00009800
                                                                        00009900
       77  IND-1                       PIC  9(003) COMP-3  VALUE 100.   00010000
       77  IND-2                       PIC  9(003) COMP-3  VALUE 05.    00010100
                                                                        00010200
      *----------------------------------------------------------------*00010300
       77  FILLER                      PIC  X(050)         VALUE        00010400
           '* AREA PARA ACUMULADORES *'.                                00010500
      *----------------------------------------------------------------*00010600
                                                                        00010700
       77  ACU-PAGINA                  PIC  9(003) COMP-3  VALUE ZEROS. 00010800
       77  ACU-LIDOS-ARCBCA09          PIC  9(007) COMP-3  VALUE ZEROS. 00010900
       77  ACU-GRAVA-RECBCA09          PIC  9(012) COMP-3  VALUE ZEROS. 00011000
       77  WRK-TOT-GRAV-AUX            PIC  9(007) COMP-3  VALUE ZEROS. 00011100
                                                                        00011200
      *----------------------------------------------------------------*00011300
       77  FILLER                      PIC  X(050)         VALUE        00011400
           '* AREA DE FILE-STATUS *'.                                   00011500
      *----------------------------------------------------------------*00011600
                                                                        00011700
       77  WRK-FS-ARCBCA09             PIC  X(002)         VALUE SPACES.00011800
       77  WRK-FS-RECBCA09             PIC  X(002)         VALUE SPACES.00011900
                                                                        00012000
       77  WRK-ABERTURA                PIC  X(013)         VALUE        00012100
           'NA ABERTURA'.                                               00012200
       77  WRK-LEITURA                 PIC  X(013)         VALUE        00012300
           'NA LEITURA'.                                                00012400
       77  WRK-GRAVACAO                PIC  X(013)         VALUE        00012500
           'NA GRAVACAO'.                                               00012600
       77  WRK-FECHAMENTO              PIC  X(013)         VALUE        00012700
           'NO FECHAMENTO'.                                             00012800
                                                                        00012900
      *----------------------------------------------------------------*00013000
       77  FILLER                      PIC  X(050)         VALUE        00013100
           '* AREA PARA VARIAVEIS AUXILIARES *'.                        00013200
      *----------------------------------------------------------------*00013300
                                                                        00013400
       77  WRK-LOCAL                   PIC  X(004)         VALUE SPACES.00013500
       77  WRK-DDNAME                  PIC  X(008)         VALUE SPACES.00013600
       77  WRK-CMCD2N0F                PIC  X(008)         VALUE        00013700
           'CMCD2N0F'.                                                  00013800
                                                                        00013900
       01  WRK-ABEND                   PIC  X(001)         VALUE SPACES.00014000
           88 WRK-ABENDAR              VALUE 'S'.                       00014100
                                                                        00014200
       01  WRK-MSG-ARQ-VAZIO           PIC  X(059)         VALUE        00014300
           'ARQUIVO VAZIO. PROCESSAMENTO ENCERRADO'.                    00014400
                                                                        00014500
       01  WRK-LINDET-COMP             PIC 9(07) COMP-3 VALUE ZEROS.    00014600
-                                                                       00014700
       01  WRK-PARAGRAFO               PIC  X(20)        VALUE SPACES.  00014800
       01  WRK-FILE-STATUS             PIC  X(02)        VALUE SPACES.  00014900
       01  WRK-NOME-ARQUIVO            PIC  X(08)        VALUE SPACES.  00015000
       01  WRK-COMANDO                 PIC  X(05)        VALUE SPACES.  00015100
-                                                                       00015200
       01  WRK-AREA-DATAS.                                              00015300
           03      WRK-DATA-8          PIC  9(009) VALUE ZEROS.         00015400
           03      FILLER              REDEFINES WRK-DATA-8.            00015500
               05  FILLER              PIC  9(001).                     00015600
               05  WRK-ANO-8           PIC  9(004).                     00015700
               05  WRK-MES-8           PIC  9(002).                     00015800
               05  WRK-DIA-8           PIC  9(002).                     00015900
           03      WRK-DATA-10.                                         00016000
               05  WRK-DIA-10          PIC  9(002) VALUE ZEROS.         00016100
               05  FILLER              PIC  X(001) VALUE '/'.           00016200
               05  WRK-MES-10          PIC  9(002) VALUE ZEROS.         00016300
               05  FILLER              PIC  X(001) VALUE '/'.           00016400
               05  WRK-ANO-10          PIC  9(004) VALUE ZEROS.         00016500
                                                                        00016600
       01  WRK-DATA-DE-HOJE.                                            00016700
           03      WRK-DATA-HOJE.                                       00016800
               05  FILLER              PIC X(07).                       00016900
               05  WRK-DT-HOJE         PIC 9(09) COMP-3 VALUE ZEROS.    00017000
               05  WRK-HHMMSS          PIC 9(07) COMP-3 VALUE ZEROS.    00017100
               05  FILLER              PIC X(27).                       00017200
                                                                        00017300
      *----------------------------------------------------------------*00017400
       01  FILLER                      PIC  X(050)         VALUE        00017500
           'AREA PARA LAYOUT DOS CABECALHOS'.                           00017600
      *----------------------------------------------------------------*00017700
                                                                        00017800
       01  CB1-CABEC1.                                                  00017900
           05 FILLER                   PIC  X(001)         VALUE '1'.   00018000
           05 FILLER                   PIC  X(008)         VALUE        00018100
              'CMCD2NER'.                                               00018200
           05 FILLER                   PIC  X(041)         VALUE SPACES.00018300
           05 FILLER                   PIC  X(037)         VALUE        00018400
              'BANCO BRADESCO S/A - SISTEMA COBRANCA'.                  00018500
           05 FILLER                   PIC  X(033)         VALUE SPACES.00018600
           05 FILLER                   PIC  X(008)         VALUE        00018700
              'PAGINA: '.                                               00018800
           05 CB1-PAG             PIC  ZZZZ9               VALUE ZEROS. 00018900
                                                                        00019000
       01  CB2-CABEC2.                                                  00019100
           05 FILLER                   PIC  X(001)         VALUE ' '.   00019200
           05 FILLER                   PIC  X(045)         VALUE SPACES.00019300
           05 FILLER                   PIC  X(046)         VALUE        00019400
           'RELATORIO DE PARAMETROS DE MIDIAS DE PAGAMENTO'.            00019500
           05 FILLER                   PIC  X(025)         VALUE SPACES.00019600
           05 FILLER                   PIC  X(006)         VALUE        00019700
           'DATA: '.                                                    00019800
           05 CB2-DATA-PROC.                                            00019900
             10 CB2-DIA-PROC      PIC  9(002)         VALUE ZEROS.      00020000
             10 FILLER                 PIC  X(001)         VALUE '/'.   00020100
             10 CB2-MES-PROC      PIC  9(002)         VALUE ZEROS.      00020200
             10 FILLER                 PIC  X(001)         VALUE '/'.   00020300
             10 CB2-ANO-PROC      PIC  9(004)         VALUE ZEROS.      00020400
                                                                        00020500
       01  CB3-CABEC3.                                                  00020600
           05 FILLER                   PIC  X(001)         VALUE ' '.   00020700
           05 FILLER                   PIC  X(024)         VALUE        00020800
              'TABULACAO DOS CAMPOS:'.                                  00020900
           05 FILLER                   PIC  X(092)         VALUE SPACES.00021000
                                                                        00021100
       01  CB4-CABEC4.                                                  00021200
           05 FILLER                   PIC  X(001)         VALUE ' '.   00021300
           05 FILLER                   PIC  X(044)         VALUE SPACES.00021400
           05 FILLER                   PIC  X(014)         VALUE        00021500
              'INICIO     FIM'.                                         00021600
           05 FILLER                   PIC  X(074)         VALUE SPACES.00021700
                                                                        00021800
       01  CB5-CABEC5.                                                  00021900
           05 FILLER                   PIC  X(001)         VALUE ' '.   00022000
           05 CB5-DESCR-COLUNA         PIC  X(044)         VALUE SPACES.00022100
           05 FILLER                   PIC  X(001)         VALUE SPACES.00022200
           05 CB5-VL-INI               PIC  ZZZZ9          VALUE ZEROS. 00022300
           05 FILLER                   PIC  X(003)         VALUE SPACES.00022400
           05 CB5-VL-FIM               PIC  ZZZZ9          VALUE ZEROS. 00022500
           05 FILLER                   PIC  X(074)         VALUE SPACES.00022600
                                                                        00022700
                                                                        00022800
       01  CB6-CABEC6.                                                  00022900
           05 FILLER                   PIC  X(001)         VALUE ' '.   00023000
           05 FILLER                   PIC  X(011) VALUE SPACES.        00023100
           05 FILLER                   PIC  X(100)         VALUE        00023200
              '         1         2         3         4         5       00023300
      -       '  6         7         8         9         0'.            00023400
           05 FILLER                   PIC  X(021) VALUE SPACES.        00023500
                                                                        00023600
                                                                        00023700
       01  CB7-CABEC7.                                                  00023800
           05 FILLER                   PIC  X(001)         VALUE ' '.   00023900
           05 FILLER                   PIC  X(011) VALUE SPACES.        00024000
           05 FILLER                   PIC  X(100)         VALUE        00024100
              '12345678901234567890123456789012345678901234567890123456700024200
      -       '8901234567890123456789012345678901234567890'.            00024300
           05 FILLER                   PIC  X(021) VALUE SPACES.        00024400
                                                                        00024500
                                                                        00024600
      *----------------------------------------------------------------*00024700
       01  FILLER                      PIC  X(050)         VALUE        00024800
           'AREA PARA LAYOUT DE LINHAS DE DETALHE'.                     00024900
      *----------------------------------------------------------------*00025000
                                                                        00025100
       01  LD1-LINDET1.                                                 00025200
           05 FILLER                   PIC  X(001)         VALUE ' '.   00025300
           05 LD1-NRO-LINHA-X.                                          00025400
              10 LD1-NRO-LINHA         PIC  9(007)         VALUE ZEROS. 00025500
           05 FILLER                   PIC  X(001)         VALUE '.'.   00025600
           05 LD1-NRO-REG-X.                                            00025700
              10 LD1-NRO-REG           PIC  9(001)         VALUE ZEROS. 00025800
           05 FILLER                   PIC  X(002)         VALUE SPACES.00025900
           05 LD1-LINHA                PIC  X(100)         VALUE ZEROS. 00026000
           05 FILLER                   PIC  X(021)         VALUE SPACES.00026100
                                                                        00026200
       01  LD-VAZIO.                                                    00026300
           05 FILLER                   PIC  X(050)         VALUE SPACES.00026400
           05 FILLER                   PIC  X(035)         VALUE        00026500
           '** NAO HA DADOS A SEREM EXIBIDOS **'.                       00026600
           05 FILLER                   PIC  X(048)         VALUE SPACES.00026700
                                                                        00026800
      *----------------------------------------------------------------*00026900
       01  FILLER                      PIC  X(050)         VALUE        00027000
           'AREA PARA LAYOUT DE LINHAS DE TOTAIS'.                      00027100
      *----------------------------------------------------------------*00027200
                                                                        00027300
       01  LT1-LINTOT1.                                                 00027400
           05 FILLER                   PIC  X(001)       VALUE ' '.     00027500
           05 FILLER                   PIC  X(030)       VALUE          00027600
              'TOTAL DE REGISTROS LIDOS    : '.                         00027700
           05 LT1-TOTAL-LIDOS          PIC  ZZZZZZ9      VALUE ZEROS.   00027800
                                                                        00027900
       01  LT2-LINTOT2.                                                 00028000
           05 FILLER                   PIC  X(001)       VALUE ' '.     00028100
           05 FILLER                   PIC  X(030)       VALUE          00028200
              'TOTAL DE REGISTROS GRAVADOS : '.                         00028300
           05 LT2-TOTAL-GRAV           PIC  ZZZZZZ9      VALUE ZEROS.   00028400
                                                                        00028500
      *----------------------------------------------------------------*00028600
       01  FILLER                      PIC  X(050)         VALUE        00028700
           '* AREA COMPILACAO DATA/HORA *'.                             00028800
      *----------------------------------------------------------------*00028900
                                                                        00029000
       01  WRK-COMPILACAO.                                              00029100
           05 WRK-DTCOMPILA.                                            00029200
             10 WRK-MMCOMPILA          PIC  X(002)         VALUE SPACES.00029300
             10 FILLER                 PIC  X(001)         VALUE SPACES.00029400
             10 WRK-DDCOMPILA          PIC  X(002)         VALUE SPACES.00029500
             10 FILLER                 PIC  X(001)         VALUE SPACES.00029600
             10 WRK-AACOMPILA          PIC  X(002)         VALUE SPACES.00029700
           05 WRK-HRCOMPILA            PIC  X(008)         VALUE SPACES.00029800
                                                                        00029900
      *----------------------------------------------------------------*00030000
       01  FILLER                      PIC  X(050)         VALUE        00030100
           '* AREA PARA A BRAD0450 *'.                                  00030200
      *----------------------------------------------------------------*00030300
                                                                        00030400
       01  WRK-DUMP-0450               PIC  X(001)         VALUE 'S'.   00030500
       01  WRK-ABEND-0450              PIC S9(004) COMP    VALUE +1111. 00030600
                                                                        00030700
      *----------------------------------------------------------------*00030800
       01  FILLER                      PIC  X(050)         VALUE        00030900
           '* AREA DE MENSAGENS DE ERRO *'.                             00031000
      *----------------------------------------------------------------*00031100
                                                                        00031200
       01  WRK-MSG-FS.                                                  00031300
           05 FILLER                   PIC  X(005)         VALUE        00031400
              'ERRO '.                                                  00031500
           05 WRK-OPERACAO             PIC  X(013)         VALUE SPACES.00031600
           05 FILLER                   PIC  X(012)         VALUE        00031700
              ' DO ARQUIVO '.                                           00031800
           05 WRK-ARQUIVO              PIC  X(008)         VALUE SPACES.00031900
           05 FILLER                   PIC  X(016)         VALUE        00032000
              '. FILE-STATUS = '.                                       00032100
           05 WRK-FS                   PIC  X(002)         VALUE SPACES.00032200
           05 FILLER                   PIC  X(003)         VALUE SPACES.00032300
                                                                        00032400
      *----------------------------------------------------------------*00032500
       01  FILLER                      PIC  X(050)         VALUE        00032600
           '* AREA PARA CMCD2N0F - ROTINA ESTATISTICA *'.               00032700
      *----------------------------------------------------------------*00032800
                                                                        00032900
       COPY 'CMCDWES1'.                                                 00033000
                                                                        00033100
      *----------------------------------------------------------------*00033200
       01  FILLER                      PIC  X(050)         VALUE        00033300
           '* LAYOUT DO ARQUIVO DE ENTRADA ARCBCA09 *'.                 00033400
      *----------------------------------------------------------------*00033500
                                                                        00033600
       01  WRK-AREA-RECBCA09.                                           00033700
           10 WRK-CMIDIA-PGTO-TITLO    PIC S9(5) COMP-3 VALUE ZEROS.    00033800
           10 WRK-CMIDIA-PGTO-TITLO-R                                   00033900
              REDEFINES WRK-CMIDIA-PGTO-TITLO  PIC 9(5) COMP-3.         00034000
                                                                        00034100
           10 WRK-IMIDIA-PGTO-TITLO    PIC X(40) VALUE SPACES.          00034200
                                                                        00034300
           10 WRK-CORIGE-COBR          PIC S9(3) COMP-3 VALUE ZEROS.    00034400
           10 WRK-CORIGE-COBR-R                                         00034500
              REDEFINES WRK-CORIGE-COBR        PIC 9(3) COMP-3.         00034600
                                                                        00034700
           10 WRK-CEVNTO-CTBIL-BDSCO   PIC S9(4) COMP-3 VALUE ZEROS.    00034800
           10 WRK-CEVNTO-CTBIL-BDSCO-R                                  00034900
              REDEFINES WRK-CEVNTO-CTBIL-BDSCO PIC  9(4) COMP-3.        00035000
                                                                        00035100
           10 WRK-CEVNTO-CTBIL-OUTRO   PIC S9(4) COMP-3 VALUE ZEROS.    00035200
           10 WRK-CEVNTO-CTBIL-OUTRO-R                                  00035300
              REDEFINES WRK-CEVNTO-CTBIL-OUTRO PIC  9(4) COMP-3.        00035400
                                                                        00035500
           10 WRK-CLCTO-BCO-CORSP      PIC S9(5) COMP-3 VALUE ZEROS.    00035600
           10 WRK-CLCTO-BCO-CORSP-R                                     00035700
              REDEFINES WRK-CLCTO-BCO-CORSP    PIC  9(5) COMP-3.        00035800
                                                                        00035900
           10 WRK-CLCTO-CHEQ-POSTO     PIC S9(5) COMP-3 VALUE ZEROS.    00036000
           10 WRK-CLCTO-CHEQ-POSTO-R                                    00036100
              REDEFINES WRK-CLCTO-CHEQ-POSTO   PIC  9(5) COMP-3.        00036200
                                                                        00036300
           10 WRK-REXTRT-SEGDA-LIN     PIC X(32) VALUE SPACES.          00036400
           10 WRK-CINDCD-AUTRZ-EXCL    PIC X(1) VALUE SPACES.           00036500
           10 WRK-CINDCD-ACTAC-VENCD   PIC X(1) VALUE SPACES.           00036600
           10 WRK-CINDCD-ALT-VLR       PIC X(1) VALUE SPACES.           00036700
                                                                        00036800
           10 WRK-PMIN-ALT-VLR-TITLO   PIC S9(3)V99 COMP-3 VALUE ZEROS. 00036900
           10 WRK-PMIN-ALT-VLR-TITLO-R                                  00037000
              REDEFINES WRK-PMIN-ALT-VLR-TITLO PIC  9(3)V99 COMP-3.     00037100
                                                                        00037200
           10 WRK-PMAX-ALT-VLR-TITLO   PIC S9(3)V99 COMP-3 VALUE ZEROS. 00037300
           10 WRK-PMAX-ALT-VLR-TITLO-R                                  00037400
              REDEFINES WRK-PMAX-ALT-VLR-TITLO PIC  9(3)V99 COMP-3.     00037500
                                                                        00037600
           10 WRK-CTRATO-DUPDD-PGTO    PIC S9(2) COMP-3 VALUE ZEROS.    00037700
           10 WRK-CTRATO-DUPDD-PGTO-R                                   00037800
              REDEFINES WRK-CTRATO-DUPDD-PGTO PIC  9(2) COMP-3.         00037900
                                                                        00038000
           10 WRK-VMAX-MIDIA-BDSCO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00038100
           10 WRK-VMAX-MIDIA-BDSCO-R                                    00038200
              REDEFINES WRK-VMAX-MIDIA-BDSCO PIC  9(15)V99 COMP-3.      00038300
                                                                        00038400
           10 WRK-VMAX-MIDIA-OUTRO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00038500
           10 WRK-VMAX-MIDIA-OUTRO-R                                    00038600
              REDEFINES WRK-VMAX-MIDIA-OUTRO PIC  9(15)V99 COMP-3.      00038700
                                                                        00038800
           10 WRK-VMAX-ESPCE-BDSCO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00038900
           10 WRK-VMAX-ESPCE-BDSCO-R                                    00039000
              REDEFINES WRK-VMAX-ESPCE-BDSCO PIC  9(15)V99 COMP-3.      00039100
                                                                        00039200
           10 WRK-VMAX-ESPCE-OUTRO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00039300
           10 WRK-VMAX-ESPCE-OUTRO-R                                    00039400
              REDEFINES WRK-VMAX-ESPCE-OUTRO PIC  9(15)V99 COMP-3.      00039500
                                                                        00039600
           10 WRK-VMAX-CHEQ-BDSCO      PIC S9(15)V99 COMP-3 VALUE ZEROS.00039700
           10 WRK-VMAX-CHEQ-BDSCO-R                                     00039800
              REDEFINES WRK-VMAX-CHEQ-BDSCO PIC  9(15)V99 COMP-3.       00039900
                                                                        00040000
           10 WRK-VMAX-CHEQ-OUTRO      PIC S9(15)V99 COMP-3 VALUE ZEROS.00040100
           10 WRK-VMAX-CHEQ-OUTRO-R                                     00040200
              REDEFINES WRK-VMAX-CHEQ-OUTRO PIC  9(15)V99 COMP-3.       00040300
                                                                        00040400
           10 WRK-VMAX-CATAO-BDSCO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00040500
           10 WRK-VMAX-CATAO-BDSCO-R                                    00040600
              REDEFINES WRK-VMAX-CATAO-BDSCO PIC  9(15)V99 COMP-3.      00040700
                                                                        00040800
           10 WRK-VMAX-CATAO-OUTRO     PIC S9(15)V99 COMP-3 VALUE ZEROS.00040900
           10 WRK-VMAX-CATAO-OUTRO-R                                    00041000
              REDEFINES WRK-VMAX-CATAO-OUTRO PIC  9(15)V99 COMP-3.      00041100
                                                                        00041200
           10 WRK-CSGL-CTRO-PRCSR      PIC X(6) VALUE SPACES.           00041300
           10 WRK-CINDCD-AG-FERI-LOC   PIC X(1) VALUE SPACES.           00041400
           10 WRK-CTRATO-PGTO-FERI     PIC X(1) VALUE SPACES.           00041500
                                                                        00041600
      *----------------------------------------------------------------*00041700
       01  FILLER                      PIC  X(050)         VALUE        00041800
           '* AREA AUXILIAR PARA RELATORIO *'.                          00041900
      *----------------------------------------------------------------*00042000
                                                                        00042100
       01  WRK-AREA-RECBCA09-AUX.                                       00042200
           10 WRK-CMIDIA-PGTO-TITLO-AUX   PIC 9(5)   VALUE ZEROS.       00042300
           10 WRK-IMIDIA-PGTO-TITLO-AUX   PIC X(40)  VALUE SPACES.      00042400
           10 WRK-CORIGE-COBR-AUX         PIC 9(3)   VALUE ZEROS.       00042500
           10 WRK-CEVNTO-CTBIL-BDSCO-AUX  PIC 9(4)   VALUE ZEROS.       00042600
           10 WRK-CEVNTO-CTBIL-OUTRO-AUX  PIC 9(4)   VALUE ZEROS.       00042700
           10 WRK-CLCTO-BCO-CORSP-AUX     PIC 9(5)   VALUE ZEROS.       00042800
           10 WRK-CLCTO-CHEQ-POSTO-AUX    PIC 9(5)   VALUE ZEROS.       00042900
           10 WRK-REXTRT-SEGDA-LIN-AUX    PIC X(32)  VALUE SPACES.      00043000
           10 WRK-CINDCD-AUTRZ-EXCL-AUX   PIC X(1)   VALUE SPACES.      00043100
           10 WRK-CINDCD-ACTAC-VENCD-AUX  PIC X(1)   VALUE SPACES.      00043200
           10 WRK-CINDCD-ALT-VLR-AUX      PIC X(1)   VALUE SPACES.      00043300
           10 WRK-PMIN-ALT-VLR-TITLO-AUX  PIC 999,99 VALUE ZEROS.       00043400
           10 WRK-PMAX-ALT-VLR-TITLO-AUX  PIC 999,99 VALUE ZEROS.       00043500
           10 WRK-CTRATO-DUPDD-PGTO-AUX   PIC 9(2)   VALUE ZEROS.       00043600
           10 WRK-VMAX-MIDIA-BDSCO-AUX    PIC 999999999999999,99        00043700
                                                     VALUE ZEROS.       00043800
           10 WRK-VMAX-MIDIA-OUTRO-AUX    PIC 999999999999999,99        00043900
                                                     VALUE ZEROS.       00044000
           10 WRK-VMAX-ESPCE-BDSCO-AUX    PIC 999999999999999,99        00044100
                                                     VALUE ZEROS.       00044200
           10 WRK-VMAX-ESPCE-OUTRO-AUX    PIC 999999999999999,99        00044300
                                                     VALUE ZEROS.       00044400
           10 WRK-VMAX-CHEQ-BDSCO-AUX     PIC 999999999999999,99        00044500
                                                     VALUE ZEROS.       00044600
           10 WRK-VMAX-CHEQ-OUTRO-AUX     PIC 999999999999999,99        00044700
                                                     VALUE ZEROS.       00044800
           10 WRK-VMAX-CATAO-BDSCO-AUX    PIC 999999999999999,99        00044900
                                                     VALUE ZEROS.       00045000
           10 WRK-VMAX-CATAO-OUTRO-AUX    PIC 999999999999999,99        00045100
                                                     VALUE ZEROS.       00045200
           10 WRK-CSGL-CTRO-PRCSR-AUX     PIC X(6)   VALUE SPACES.      00045300
           10 WRK-CINDCD-AG-FERI-LOC-AUX  PIC X(1)   VALUE SPACES.      00045400
           10 WRK-CTRATO-PGTO-FERI-AUX    PIC X(1)   VALUE SPACES.      00045500
                                                                        00045600
                                                                        00045700
      *----------------------------------------------------------------*00045800
       01  FILLER                      PIC  X(050)         VALUE        00045900
           '* FIM DA WORKING STORAGE SECTION *'.                        00046000
      *----------------------------------------------------------------*00046100
                                                                        00046200
                                                                        00046300
      *================================================================*00046400
       PROCEDURE                       DIVISION.                        00046500
      *================================================================*00046600
                                                                        00046700
      ******************************************************************00046800
      *    ROTINA PRINCIPAL.                                           *00046900
      ******************************************************************00047000
      *----------------------------------------------------------------*00047100
       0000-INICIAR                        SECTION.                     00047200
      *----------------------------------------------------------------*00047300
                                                                        00047400
           CALL 'CKRS1050'.                                             00047500
                                                                        00047600
           PERFORM 1000-INICIALIZAR.                                    00047700
                                                                        00047800
           PERFORM 2000-VERIFICAR-VAZIO.                                00047900
                                                                        00048000
           PERFORM 3000-PROCESSAR       UNTIL                           00048100
                   WRK-FS-ARCBCA09          EQUAL '10'                  00048200
                                                                        00048300
           PERFORM 4000-FINALIZAR.                                      00048400
                                                                        00048500
      *----------------------------------------------------------------*00048600
       0000-99-FIM.                        EXIT.                        00048700
      *----------------------------------------------------------------*00048800
                                                                        00048900
      ******************************************************************00049000
      *    ROTINA DE INICIALIZACAO.                                    *00049100
      ******************************************************************00049200
      *----------------------------------------------------------------*00049300
       1000-INICIALIZAR                SECTION.                         00049400
      *----------------------------------------------------------------*00049500
                                                                        00049600
           INITIALIZE WRK-AREA-RECBCA09.                                00049700
                                                                        00049800
           PERFORM 1100-OBTER-DATA-SISTEMA.                             00049900
                                                                        00050000
           OPEN INPUT ARCBCA09                                          00050100
               OUTPUT RECBCA09.                                         00050200
                                                                        00050300
           MOVE '0010'                 TO WRK-LOCAL.                    00050400
           MOVE '1000-INICIALIZAR'     TO WRK-PARAGRAFO.                00050500
                                                                        00050600
           MOVE WRK-ABERTURA           TO WRK-OPERACAO.                 00050700
           MOVE 'OPEN'                 TO WRK-COMANDO.                  00050800
                                                                        00050900
           PERFORM 1200-TESTAR-FILE-STATUS.                             00051000
                                                                        00051100
      *----------------------------------------------------------------*00051200
       1000-99-FIM.                    EXIT.                            00051300
      *----------------------------------------------------------------*00051400
                                                                        00051500
      ******************************************************************00051600
      *    OBTER DATA DO SISTEMA - PROGRAMA POOL7600.                  *00051700
      ******************************************************************00051800
      *----------------------------------------------------------------*00051900
       1100-OBTER-DATA-SISTEMA         SECTION.                         00052000
      *----------------------------------------------------------------*00052100
                                                                        00052200
           INITIALIZE WRK-DATA-HOJE.                                    00052300
                                                                        00052400
           CALL    'POOL7600'  USING   WRK-DATA-HOJE.                   00052500
                                                                        00052600
           MOVE  WRK-DT-HOJE         TO  WRK-DATA-8.                    00052700
                                                                        00052800
           MOVE  WRK-DIA-8           TO  WRK-DIA-10.                    00052900
           MOVE  WRK-MES-8           TO  WRK-MES-10.                    00053000
           MOVE  WRK-ANO-8           TO  WRK-ANO-10.                    00053100
                                                                        00053200
      *----------------------------------------------------------------*00053300
       1100-99-FIM.                    EXIT.                            00053400
      *----------------------------------------------------------------*00053500
                                                                        00053600
      ******************************************************************00053700
      *    TESTE DE FILE STATUS.                                       *00053800
      ******************************************************************00053900
      *----------------------------------------------------------------*00054000
       1200-TESTAR-FILE-STATUS         SECTION.                         00054100
      *----------------------------------------------------------------*00054200
                                                                        00054300
           PERFORM 1210-TESTAR-FS-ARCBCA09.                             00054400
                                                                        00054500
           PERFORM 1220-TESTAR-FS-RECBCA09.                             00054600
                                                                        00054700
      *----------------------------------------------------------------*00054800
       1200-99-FIM.                    EXIT.                            00054900
      *----------------------------------------------------------------*00055000
                                                                        00055100
      ******************************************************************00055200
      *    TESTE DE FILE-STATUS DO ARQUIVO ARCBCA09.                   *00055300
      ******************************************************************00055400
      *----------------------------------------------------------------*00055500
       1210-TESTAR-FS-ARCBCA09           SECTION.                       00055600
      *----------------------------------------------------------------*00055700
                                                                        00055800
           IF  WRK-FS-ARCBCA09           NOT EQUAL '00'                 00055900
               MOVE 'ARCBCA09'           TO WRK-ARQUIVO                 00056000
                                            WRK-NOME-ARQUIVO            00056100
               MOVE WRK-FS-ARCBCA09      TO WRK-FS                      00056200
                                            WRK-FILE-STATUS             00056300
               PERFORM 8000-CHAMAR-CMCD2N0F                             00056400
               SET WRK-ABENDAR         TO TRUE                          00056500
               PERFORM 9996-ERRO-ARQUIVO                                00056600
           END-IF.                                                      00056700
                                                                        00056800
      *----------------------------------------------------------------*00056900
       1210-99-FIM.                    EXIT.                            00057000
      *----------------------------------------------------------------*00057100
                                                                        00057200
      ******************************************************************00057300
      *    TESTE DE FILE-STATUS DO ARQUIVO RECBCA09                     00057400
      ******************************************************************00057500
      *----------------------------------------------------------------*00057600
       1220-TESTAR-FS-RECBCA09           SECTION.                       00057700
      *----------------------------------------------------------------*00057800
                                                                        00057900
           IF  WRK-FS-RECBCA09           NOT EQUAL '00'                 00058000
               MOVE 'RECBCA09'           TO WRK-ARQUIVO                 00058100
                                            WRK-NOME-ARQUIVO            00058200
               MOVE WRK-FS-RECBCA09      TO WRK-FS                      00058300
                                            WRK-FILE-STATUS             00058400
               MOVE WRK-MSG-FS           TO CMCDWES1-COMENTARIO(1)      00058500
               PERFORM 8000-CHAMAR-CMCD2N0F                             00058600
               SET WRK-ABENDAR         TO TRUE                          00058700
               PERFORM 9996-ERRO-ARQUIVO                                00058800
           END-IF.                                                      00058900
                                                                        00059000
      *----------------------------------------------------------------*00059100
       1220-99-FIM.                    EXIT.                            00059200
      *----------------------------------------------------------------*00059300
                                                                        00059400
      ******************************************************************00059500
      *    VERIFICACAO DE VAZIO DOS ARQUIVOS.                          *00059600
      ******************************************************************00059700
      *----------------------------------------------------------------*00059800
       2000-VERIFICAR-VAZIO            SECTION.                         00059900
      *----------------------------------------------------------------*00060000
                                                                        00060100
           PERFORM 2100-LER-ARCBCA09.                                   00060200
                                                                        00060300
           IF  WRK-FS-ARCBCA09           EQUAL '10'                     00060400
               MOVE WRK-MSG-ARQ-VAZIO  TO CMCDWES1-COMENTARIO(1)        00060500
               PERFORM 2200-IMPRIMIR-VAZIO                              00060600
               PERFORM 4000-FINALIZAR                                   00060700
           END-IF.                                                      00060800
                                                                        00060900
      *----------------------------------------------------------------*00061000
       2000-99-FIM.                    EXIT.                            00061100
      *----------------------------------------------------------------*00061200
                                                                        00061300
      ******************************************************************00061400
      *    EFETUA LEITURA DO ARQUIVO ARCBCA09.                         *00061500
      ******************************************************************00061600
      *----------------------------------------------------------------*00061700
       2100-LER-ARCBCA09               SECTION.                         00061800
      *----------------------------------------------------------------*00061900
                                                                        00062000
           READ ARCBCA09               INTO WRK-AREA-RECBCA09.          00062100
                                                                        00062200
           IF  WRK-FS-ARCBCA09         EQUAL '10'                       00062300
               GO TO 2100-99-FIM                                        00062400
           END-IF.                                                      00062500
                                                                        00062600
           MOVE '0050'                 TO WRK-LOCAL.                    00062700
           MOVE '2100-LER-ARCBCA09'    TO WRK-PARAGRAFO.                00062800
                                                                        00062900
           MOVE WRK-LEITURA            TO WRK-OPERACAO.                 00063000
           MOVE 'READ'                 TO WRK-COMANDO.                  00063100
                                                                        00063200
           PERFORM 1210-TESTAR-FS-ARCBCA09.                             00063300
                                                                        00063400
           ADD 1                       TO ACU-LIDOS-ARCBCA09.           00063500
                                                                        00063600
      *----------------------------------------------------------------*00063700
       2100-99-FIM.                    EXIT.                            00063800
      *----------------------------------------------------------------*00063900
                                                                        00064000
      *----------------------------------------------------------------*00064100
       2200-IMPRIMIR-VAZIO             SECTION.                         00064200
      *----------------------------------------------------------------*00064300
                                                                        00064400
           ADD 1                       TO ACU-PAGINA                    00064500
           MOVE ACU-PAGINA             TO CB1-PAG.                      00064600
           MOVE ZEROS                  TO IND-1.                        00064700
                                                                        00064800
           MOVE CB1-CABEC1             TO FD-RECBCA09                   00064900
           PERFORM 3110-GRAVAR-RECBCA09.                                00065000
                                                                        00065100
           MOVE WRK-DATA-10            TO CB2-DATA-PROC.                00065200
           MOVE CB2-CABEC2             TO FD-RECBCA09.                  00065300
           PERFORM 3110-GRAVAR-RECBCA09.                                00065400
                                                                        00065500
           MOVE SPACES                 TO FD-RECBCA09                   00065600
           PERFORM 3110-GRAVAR-RECBCA09.                                00065700
                                                                        00065800
           MOVE LD-VAZIO               TO FD-RECBCA09.                  00065900
           PERFORM 3110-GRAVAR-RECBCA09.                                00066000
                                                                        00066100
      *----------------------------------------------------------------*00066200
       2200-99-FIM.                    EXIT.                            00066300
      *----------------------------------------------------------------*00066400
                                                                        00066500
      ******************************************************************00066600
      *    PROCESSAMENTO PRINCIPAL.                                    *00066700
      ******************************************************************00066800
      *----------------------------------------------------------------*00066900
       3000-PROCESSAR                  SECTION.                         00067000
      *----------------------------------------------------------------*00067100
                                                                        00067200
           IF IND-1                    GREATER 99                       00067300
              PERFORM 3100-IMPRIMIR-CABEC-1                             00067400
              MOVE ZEROS               TO IND-1                         00067500
           END-IF.                                                      00067600
                                                                        00067700
           IF IND-2                    GREATER 04                       00067800
              PERFORM 3200-IMPRIMIR-CABEC-2                             00067900
              MOVE ZEROS               TO IND-2                         00068000
           END-IF.                                                      00068100
                                                                        00068200
           PERFORM 3300-IMPRIMIR-LINDET.                                00068300
                                                                        00068400
           ADD 1                       TO IND-1                         00068500
                                          IND-2.                        00068600
                                                                        00068700
           PERFORM 2100-LER-ARCBCA09.                                   00068800
                                                                        00068900
      *----------------------------------------------------------------*00069000
       3000-99-FIM.                    EXIT.                            00069100
      *----------------------------------------------------------------*00069200
                                                                        00069300
      *----------------------------------------------------------------*00069400
       3100-IMPRIMIR-CABEC-1           SECTION.                         00069500
      *----------------------------------------------------------------*00069600
                                                                        00069700
           ADD 1                       TO ACU-PAGINA                    00069800
           MOVE ACU-PAGINA             TO CB1-PAG.                      00069900
                                                                        00070000
           MOVE CB1-CABEC1             TO FD-RECBCA09                   00070100
           PERFORM 3110-GRAVAR-RECBCA09.                                00070200
                                                                        00070300
           MOVE WRK-DATA-10            TO CB2-DATA-PROC.                00070400
           MOVE CB2-CABEC2             TO FD-RECBCA09.                  00070500
           PERFORM 3110-GRAVAR-RECBCA09.                                00070600
                                                                        00070700
           MOVE SPACES                 TO FD-RECBCA09.                  00070800
           PERFORM 3110-GRAVAR-RECBCA09.                                00070900
                                                                        00071000
           MOVE CB3-CABEC3             TO FD-RECBCA09.                  00071100
           PERFORM 3110-GRAVAR-RECBCA09.                                00071200
                                                                        00071300
           MOVE SPACES                 TO FD-RECBCA09.                  00071400
           PERFORM 3110-GRAVAR-RECBCA09.                                00071500
                                                                        00071600
           MOVE CB4-CABEC4             TO FD-RECBCA09.                  00071700
           PERFORM 3110-GRAVAR-RECBCA09.                                00071800
                                                                        00071900
           PERFORM 3120-MONTAR-DESCR-CAMPOS.                            00072000
                                                                        00072100
      *----------------------------------------------------------------*00072200
       3100-99-FIM.                    EXIT.                            00072300
      *----------------------------------------------------------------*00072400
                                                                        00072500
      *----------------------------------------------------------------*00072600
       3110-GRAVAR-RECBCA09            SECTION.                         00072700
      *----------------------------------------------------------------*00072800
                                                                        00072900
           MOVE WRK-GRAVACAO           TO WRK-OPERACAO                  00073000
           MOVE 'WRITE'                TO WRK-COMANDO.                  00073100
                                                                        00073200
           WRITE FD-RECBCA09.                                           00073300
           PERFORM 1220-TESTAR-FS-RECBCA09.                             00073400
                                                                        00073500
           ADD 1 TO ACU-GRAVA-RECBCA09.                                 00073600
                                                                        00073700
      *----------------------------------------------------------------*00073800
       3110-99-FIM.                    EXIT.                            00073900
      *----------------------------------------------------------------*00074000
                                                                        00074100
      *----------------------------------------------------------------*00074200
       3120-MONTAR-DESCR-CAMPOS        SECTION.                         00074300
      *----------------------------------------------------------------*00074400
                                                                        00074500
           MOVE 'COD. MIDIA PAGAMENTO TITULO'                           00074600
                                           TO CB5-DESCR-COLUNA.         00074700
           MOVE 1                          TO CB5-VL-INI                00074800
           MOVE 5                          TO CB5-VL-FIM                00074900
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00075000
           PERFORM 3110-GRAVAR-RECBCA09.                                00075100
                                                                        00075200
           MOVE 'DESCRICAO MIDIA PAGAMENTO TITULO'                      00075300
                                           TO CB5-DESCR-COLUNA.         00075400
           MOVE 6                          TO CB5-VL-INI                00075500
           MOVE 45                         TO CB5-VL-FIM                00075600
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00075700
           PERFORM 3110-GRAVAR-RECBCA09.                                00075800
                                                                        00075900
           MOVE 'COD. ORIGEM COBRANCA'     TO CB5-DESCR-COLUNA.         00076000
           MOVE 46                         TO CB5-VL-INI                00076100
           MOVE 48                         TO CB5-VL-FIM                00076200
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00076300
           PERFORM 3110-GRAVAR-RECBCA09.                                00076400
                                                                        00076500
           MOVE 'COD. EVENTO CONTABIL PARA TITULOS BRADESCO'            00076600
                                           TO CB5-DESCR-COLUNA.         00076700
           MOVE 49                         TO CB5-VL-INI                00076800
           MOVE 52                         TO CB5-VL-FIM                00076900
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00077000
           PERFORM 3110-GRAVAR-RECBCA09.                                00077100
                                                                        00077200
           MOVE 'COD. EVENTO CONTABIL TITULOS OUTROS BANCOS'            00077300
                                       TO CB5-DESCR-COLUNA.             00077400
           MOVE 53                     TO CB5-VL-INI                    00077500
           MOVE 56                     TO CB5-VL-FIM                    00077600
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00077700
           PERFORM 3110-GRAVAR-RECBCA09.                                00077800
                                                                        00077900
           MOVE 'COD. LANCAMENTO BANCO CORRESPONDENTE'                  00078000
                                       TO CB5-DESCR-COLUNA.             00078100
           MOVE 57                     TO CB5-VL-INI                    00078200
           MOVE 61                     TO CB5-VL-FIM                    00078300
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00078400
           PERFORM 3110-GRAVAR-RECBCA09.                                00078500
                                                                        00078600
           MOVE 'COD. LANCAMENTO CHEQUE POSTO'                          00078700
                                       TO CB5-DESCR-COLUNA.             00078800
           MOVE 62                     TO CB5-VL-INI                    00078900
           MOVE 66                     TO CB5-VL-FIM                    00079000
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00079100
           PERFORM 3110-GRAVAR-RECBCA09.                                00079200
                                                                        00079300
           MOVE 'DESCRICAO DA SEGUNDA LINHA DE EXTRATO'                 00079400
                                           TO CB5-DESCR-COLUNA.         00079500
                                                                        00079600
           MOVE 67                         TO CB5-VL-INI                00079700
           MOVE 98                         TO CB5-VL-FIM                00079800
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00079900
           PERFORM 3110-GRAVAR-RECBCA09.                                00080000
                                                                        00080100
           MOVE 'AUTORIZA EXCLUSAO DE PAGAMENTO'                        00080200
                                           TO CB5-DESCR-COLUNA.         00080300
           MOVE 99                         TO CB5-VL-INI                00080400
           MOVE 99                         TO CB5-VL-FIM                00080500
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00080600
           PERFORM 3110-GRAVAR-RECBCA09.                                00080700
                                                                        00080800
           MOVE 'AUTORIZA PAGAMENTO TIT. S/REGISTRO VENCIDO'            00080900
                                           TO CB5-DESCR-COLUNA.         00081000
           MOVE 100                        TO CB5-VL-INI                00081100
           MOVE 100                        TO CB5-VL-FIM                00081200
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00081300
           PERFORM 3110-GRAVAR-RECBCA09.                                00081400
                                                                        00081500
           MOVE 'AUTORIZA PAGTO C/ VALOR DIFERENTE DO TIT.'             00081600
                                           TO CB5-DESCR-COLUNA.         00081700
           MOVE 101                        TO CB5-VL-INI                00081800
           MOVE 101                        TO CB5-VL-FIM                00081900
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00082000
           PERFORM 3110-GRAVAR-RECBCA09.                                00082100
                                                                        00082200
           MOVE 'PERCENTUAL MIN PAGAMENTO DIFERENCA'                    00082300
                                           TO CB5-DESCR-COLUNA.         00082400
           MOVE 102                        TO CB5-VL-INI                00082500
           MOVE 107                        TO CB5-VL-FIM                00082600
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00082700
           PERFORM 3110-GRAVAR-RECBCA09.                                00082800
                                                                        00082900
           MOVE 'PERCENTUAL MAX PAGAMENTO DIFERENCA'                    00083000
                                           TO CB5-DESCR-COLUNA.         00083100
           MOVE 108                        TO CB5-VL-INI                00083200
           MOVE 113                        TO CB5-VL-FIM                00083300
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00083400
           PERFORM 3110-GRAVAR-RECBCA09.                                00083500
                                                                        00083600
           MOVE 'COD. TRATAMENTO PAGAMENTO DUPLICADO'                   00083700
                                           TO CB5-DESCR-COLUNA.         00083800
           MOVE 114                        TO CB5-VL-INI                00083900
           MOVE 115                        TO CB5-VL-FIM                00084000
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00084100
           PERFORM 3110-GRAVAR-RECBCA09.                                00084200
                                                                        00084300
           MOVE 'VALOR MAX MIDIA BRADESCO' TO CB5-DESCR-COLUNA.         00084400
           MOVE 116                        TO CB5-VL-INI                00084500
           MOVE 133                        TO CB5-VL-FIM                00084600
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00084700
           PERFORM 3110-GRAVAR-RECBCA09.                                00084800
                                                                        00084900
           MOVE 'VALOR MAX MIDIA OUTROS BANCOS'                         00085000
                                           TO CB5-DESCR-COLUNA.         00085100
           MOVE 134                        TO CB5-VL-INI                00085200
           MOVE 151                        TO CB5-VL-FIM                00085300
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00085400
           PERFORM 3110-GRAVAR-RECBCA09.                                00085500
                                                                        00085600
           MOVE 'VALOR MAX ESPECIE BRADESCO'                            00085700
                                           TO CB5-DESCR-COLUNA.         00085800
           MOVE 152                        TO CB5-VL-INI                00085900
           MOVE 169                        TO CB5-VL-FIM                00086000
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00086100
           PERFORM 3110-GRAVAR-RECBCA09.                                00086200
                                                                        00086300
           MOVE 'VALOR MAX ESPECIE OUTROS BANCOS'                       00086400
                                           TO CB5-DESCR-COLUNA.         00086500
           MOVE 170                        TO CB5-VL-INI                00086600
           MOVE 187                        TO CB5-VL-FIM                00086700
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00086800
           PERFORM 3110-GRAVAR-RECBCA09.                                00086900
                                                                        00087000
           MOVE 'VALOR MAX CHEQUE BRADESCO'                             00087100
                                           TO CB5-DESCR-COLUNA.         00087200
           MOVE 188                        TO CB5-VL-INI                00087300
           MOVE 205                        TO CB5-VL-FIM                00087400
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00087500
           PERFORM 3110-GRAVAR-RECBCA09.                                00087600
                                                                        00087700
           MOVE 'VALOR MAX CHEQUE OUTROS BANCOS'                        00087800
                                           TO CB5-DESCR-COLUNA.         00087900
           MOVE 206                        TO CB5-VL-INI                00088000
           MOVE 223                        TO CB5-VL-FIM                00088100
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00088200
           PERFORM 3110-GRAVAR-RECBCA09.                                00088300
                                                                        00088400
           MOVE 'VALOR MAX CARTAO BRADESCO'                             00088500
                                           TO CB5-DESCR-COLUNA.         00088600
           MOVE 224                        TO CB5-VL-INI                00088700
           MOVE 241                        TO CB5-VL-FIM                00088800
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00088900
           PERFORM 3110-GRAVAR-RECBCA09.                                00089000
                                                                        00089100
           MOVE 'VALOR MAX CARTAO OUTROS BANCOS'                        00089200
                                           TO CB5-DESCR-COLUNA.         00089300
           MOVE 242                        TO CB5-VL-INI                00089400
           MOVE 259                        TO CB5-VL-FIM                00089500
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00089600
           PERFORM 3110-GRAVAR-RECBCA09.                                00089700
                                                                        00089800
           MOVE 'COD. SIGLA CENTRO PROCESSADOR'                         00089900
                                           TO CB5-DESCR-COLUNA.         00090000
           MOVE 260                        TO CB5-VL-INI                00090100
           MOVE 265                        TO CB5-VL-FIM                00090200
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00090300
           PERFORM 3110-GRAVAR-RECBCA09.                                00090400
                                                                        00090500
           MOVE 'COD. INDICADOR AGENCIA FERIADO LOCAL'                  00090600
                                           TO CB5-DESCR-COLUNA.         00090700
           MOVE 266                        TO CB5-VL-INI                00090800
           MOVE 266                        TO CB5-VL-FIM                00090900
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00091000
           PERFORM 3110-GRAVAR-RECBCA09.                                00091100
                                                                        00091200
           MOVE 'COD. TRATAMENTO PAGAMENTO FERIADO'                     00091300
                                           TO CB5-DESCR-COLUNA.         00091400
           MOVE 267                        TO CB5-VL-INI                00091500
           MOVE 267                        TO CB5-VL-FIM                00091600
           MOVE CB5-CABEC5             TO FD-RECBCA09.                  00091700
           PERFORM 3110-GRAVAR-RECBCA09.                                00091800
                                                                        00091900
      *----------------------------------------------------------------*00092000
       3120-99-FIM.                    EXIT.                            00092100
      *----------------------------------------------------------------*00092200
                                                                        00092300
      *----------------------------------------------------------------*00092400
       3200-IMPRIMIR-CABEC-2           SECTION.                         00092500
      *----------------------------------------------------------------*00092600
                                                                        00092700
           MOVE SPACES                 TO FD-RECBCA09.                  00092800
           PERFORM 3110-GRAVAR-RECBCA09.                                00092900
                                                                        00093000
           MOVE CB6-CABEC6             TO FD-RECBCA09.                  00093100
           PERFORM 3110-GRAVAR-RECBCA09.                                00093200
                                                                        00093300
           MOVE CB7-CABEC7             TO FD-RECBCA09.                  00093400
           PERFORM 3110-GRAVAR-RECBCA09.                                00093500
                                                                        00093600
           MOVE SPACES                 TO FD-RECBCA09.                  00093700
           PERFORM 3110-GRAVAR-RECBCA09.                                00093800
                                                                        00093900
      *----------------------------------------------------------------*00094000
       3200-99-FIM.                    EXIT.                            00094100
      *----------------------------------------------------------------*00094200
                                                                        00094300
      *----------------------------------------------------------------*00094400
       3300-IMPRIMIR-LINDET            SECTION.                         00094500
      *----------------------------------------------------------------*00094600
                                                                        00094700
           ADD 1                        TO WRK-LINDET-COMP              00094800
           MOVE WRK-LINDET-COMP         TO LD1-NRO-LINHA                00094900
                                                                        00095000
           MOVE WRK-CMIDIA-PGTO-TITLO-R  TO WRK-CMIDIA-PGTO-TITLO-AUX   00095100
           MOVE WRK-IMIDIA-PGTO-TITLO    TO WRK-IMIDIA-PGTO-TITLO-AUX   00095200
           MOVE WRK-CORIGE-COBR-R        TO WRK-CORIGE-COBR-AUX         00095300
           MOVE WRK-CEVNTO-CTBIL-BDSCO-R TO WRK-CEVNTO-CTBIL-BDSCO-AUX  00095400
           MOVE WRK-CEVNTO-CTBIL-OUTRO-R TO WRK-CEVNTO-CTBIL-OUTRO-AUX  00095500
           MOVE WRK-CLCTO-BCO-CORSP-R    TO WRK-CLCTO-BCO-CORSP-AUX     00095600
           MOVE WRK-CLCTO-CHEQ-POSTO-R   TO WRK-CLCTO-CHEQ-POSTO-AUX    00095700
           MOVE WRK-REXTRT-SEGDA-LIN     TO WRK-REXTRT-SEGDA-LIN-AUX    00095800
           MOVE WRK-CINDCD-AUTRZ-EXCL    TO WRK-CINDCD-AUTRZ-EXCL-AUX   00095900
           MOVE WRK-CINDCD-ACTAC-VENCD   TO WRK-CINDCD-ACTAC-VENCD-AUX  00096000
           MOVE WRK-CINDCD-ALT-VLR       TO WRK-CINDCD-ALT-VLR-AUX      00096100
           MOVE WRK-PMIN-ALT-VLR-TITLO-R TO WRK-PMIN-ALT-VLR-TITLO-AUX  00096200
           MOVE WRK-PMAX-ALT-VLR-TITLO-R TO WRK-PMAX-ALT-VLR-TITLO-AUX  00096300
           MOVE WRK-CTRATO-DUPDD-PGTO-R  TO WRK-CTRATO-DUPDD-PGTO-AUX   00096400
           MOVE WRK-VMAX-MIDIA-BDSCO-R   TO WRK-VMAX-MIDIA-BDSCO-AUX    00096500
           MOVE WRK-VMAX-MIDIA-OUTRO-R   TO WRK-VMAX-MIDIA-OUTRO-AUX    00096600
           MOVE WRK-VMAX-ESPCE-BDSCO-R   TO WRK-VMAX-ESPCE-BDSCO-AUX    00096700
           MOVE WRK-VMAX-ESPCE-OUTRO-R   TO WRK-VMAX-ESPCE-OUTRO-AUX    00096800
           MOVE WRK-VMAX-CHEQ-BDSCO-R    TO WRK-VMAX-CHEQ-BDSCO-AUX     00096900
           MOVE WRK-VMAX-CHEQ-OUTRO-R    TO WRK-VMAX-CHEQ-OUTRO-AUX     00097000
           MOVE WRK-VMAX-CATAO-BDSCO-R   TO WRK-VMAX-CATAO-BDSCO-AUX    00097100
           MOVE WRK-VMAX-CATAO-OUTRO-R   TO WRK-VMAX-CATAO-OUTRO-AUX    00097200
           MOVE WRK-CSGL-CTRO-PRCSR      TO WRK-CSGL-CTRO-PRCSR-AUX     00097300
           MOVE WRK-CINDCD-AG-FERI-LOC   TO WRK-CINDCD-AG-FERI-LOC-AUX  00097400
           MOVE WRK-CTRATO-PGTO-FERI     TO WRK-CTRATO-PGTO-FERI-AUX    00097500
                                                                        00097600
           MOVE 0                        TO  LD1-NRO-REG.               00097700
           MOVE WRK-AREA-RECBCA09-AUX(1:100)  TO LD1-LINHA.             00097800
                                                                        00097900
           MOVE LD1-LINDET1            TO FD-RECBCA09                   00098000
           PERFORM 3110-GRAVAR-RECBCA09.                                00098100
                                                                        00098200
           MOVE 1                        TO  LD1-NRO-REG.               00098300
           MOVE WRK-AREA-RECBCA09-AUX(101:100)  TO LD1-LINHA.           00098400
                                                                        00098500
           MOVE LD1-LINDET1            TO FD-RECBCA09                   00098600
           PERFORM 3110-GRAVAR-RECBCA09.                                00098700
                                                                        00098800
           MOVE 2                        TO  LD1-NRO-REG.               00098900
           MOVE WRK-AREA-RECBCA09-AUX(201:67)  TO LD1-LINHA.            00099000
                                                                        00099100
           MOVE LD1-LINDET1            TO FD-RECBCA09                   00099200
           PERFORM 3110-GRAVAR-RECBCA09.                                00099300
                                                                        00099400
           ADD 1                       TO WRK-TOT-GRAV-AUX.             00099500
                                                                        00099600
      *----------------------------------------------------------------*00099700
       3300-99-FIM.                    EXIT.                            00099800
      *----------------------------------------------------------------*00099900
                                                                        00100000
      ******************************************************************00100100
      *    FINALIZAR PROCESSAMENTO.                                    *00100200
      ******************************************************************00100300
      *----------------------------------------------------------------*00100400
       4000-FINALIZAR                  SECTION.                         00100500
      *----------------------------------------------------------------*00100600
                                                                        00100700
           IF  WRK-TOT-GRAV-AUX        GREATER ZEROS                    00100800
               PERFORM 4100-IMPRIMIR-TOTAL                              00100900
           END-IF.                                                      00101000
                                                                        00101100
           CLOSE ARCBCA09                                               00101200
                 RECBCA09.                                              00101300
                                                                        00101400
           MOVE '0130'                 TO WRK-LOCAL.                    00101500
           MOVE '3000-FINALIZAR'       TO WRK-PARAGRAFO.                00101600
                                                                        00101700
           MOVE WRK-FECHAMENTO         TO WRK-OPERACAO.                 00101800
           MOVE 'CLOSE'                TO WRK-COMANDO.                  00101900
--                                                                      00102000
           PERFORM 1200-TESTAR-FILE-STATUS.                             00102100
                                                                        00102200
           PERFORM 4200-GERAR-ESTATISTICA.                              00102300
                                                                        00102400
           STOP RUN.                                                    00102500
                                                                        00102600
      *----------------------------------------------------------------*00102700
       4000-99-FIM.                    EXIT.                            00102800
      *----------------------------------------------------------------*00102900
                                                                        00103000
      *----------------------------------------------------------------*00103100
       4100-IMPRIMIR-TOTAL             SECTION.                         00103200
      *----------------------------------------------------------------*00103300
                                                                        00103400
           MOVE SPACES                 TO FD-RECBCA09.                  00103500
           PERFORM 3110-GRAVAR-RECBCA09.                                00103600
                                                                        00103700
           MOVE ACU-LIDOS-ARCBCA09     TO LT1-TOTAL-LIDOS.              00103800
           WRITE FD-RECBCA09           FROM LT1-LINTOT1.                00103900
           PERFORM 1220-TESTAR-FS-RECBCA09                              00104000
                                                                        00104100
           MOVE WRK-TOT-GRAV-AUX       TO LT2-TOTAL-GRAV.               00104200
           WRITE FD-RECBCA09           FROM LT2-LINTOT2.                00104300
           PERFORM 1220-TESTAR-FS-RECBCA09.                             00104400
                                                                        00104500
      *----------------------------------------------------------------*00104600
       4100-99-FIM.                    EXIT.                            00104700
      *----------------------------------------------------------------*00104800
                                                                        00104900
      ******************************************************************00105000
      *    GERACAO DE ESTATISTICAS DE PROCESSAMENTO.                   *00105100
      ******************************************************************00105200
      *----------------------------------------------------------------*00105300
       4200-GERAR-ESTATISTICA          SECTION.                         00105400
      *----------------------------------------------------------------*00105500
                                                                        00105600
           MOVE 'I'                      TO CMCDWES1-I-O(1).            00105700
           MOVE 'ARCBCA09'               TO WRK-DDNAME.                 00105800
           MOVE WRK-DDNAME               TO CMCDWES1-DDNAME(1).         00105900
           MOVE 'ARQ. TABELA CBCAB009'   TO CMCDWES1-DESCARQ(1).        00106000
           MOVE ACU-LIDOS-ARCBCA09       TO CMCDWES1-QTDEARQ(1).        00106100
                                                                        00106200
           MOVE 'O'                      TO CMCDWES1-I-O(2).            00106300
           MOVE 'RECBCA09'               TO WRK-DDNAME.                 00106400
           MOVE WRK-DDNAME               TO CMCDWES1-DDNAME(2).         00106500
           MOVE 'REL. TABELA CBCAB009'   TO CMCDWES1-DESCARQ(2).        00106600
           MOVE ACU-GRAVA-RECBCA09       TO CMCDWES1-QTDEARQ(2).        00106700
                                                                        00106800
           PERFORM 8000-CHAMAR-CMCD2N0F.                                00106900
                                                                        00107000
      *----------------------------------------------------------------*00107100
       4200-99-FIM.                    EXIT.                            00107200
      *----------------------------------------------------------------*00107300
                                                                        00107400
      ******************************************************************00107500
      *    PROCESSAMENTO DE ERRO DE MODULO.                            *00107600
      ******************************************************************00107700
      *----------------------------------------------------------------*00107800
       8000-CHAMAR-CMCD2N0F            SECTION.                         00107900
      *----------------------------------------------------------------*00108000
                                                                        00108100
           MOVE 'CMCD2NER'             TO CMCDWES1-PROGRAMA.            00108200
           MOVE 'CMCDXXXX'             TO CMCDWES1-JOBNAME.             00108300
           MOVE WHEN-COMPILED          TO WRK-COMPILACAO.               00108400
           MOVE WRK-DTCOMPILA(4:2)     TO CMCDWES1-DATA-COMP(1:2).      00108500
           MOVE WRK-DTCOMPILA(1:2)     TO CMCDWES1-DATA-COMP(4:2).      00108600
           MOVE '20'                   TO CMCDWES1-DATA-COMP(7:2).      00108700
           MOVE WRK-DTCOMPILA(7:2)     TO CMCDWES1-DATA-COMP(9:2).      00108800
           MOVE '.'                    TO CMCDWES1-DATA-COMP(3:1)       00108900
                                          CMCDWES1-DATA-COMP(6:1).      00109000
           MOVE WRK-HRCOMPILA          TO CMCDWES1-HORA-COMP.           00109100
                                                                        00109200
           CALL WRK-CMCD2N0F           USING CMCDWES1.                  00109300
                                                                        00109400
      *----------------------------------------------------------------*00109500
       8000-99-FIM.                    EXIT.                            00109600
      *----------------------------------------------------------------*00109700
                                                                        00109800
      ******************************************************************00109900
      *    PROCESSAMENTO DE ERRO DE ARQUIVO.                           *00110000
      ******************************************************************00110100
      *----------------------------------------------------------------*00110200
       9996-ERRO-ARQUIVO               SECTION.                         00110300
      *----------------------------------------------------------------*00110400
                                                                        00110500
           DISPLAY ' '.                                                 00110600
           DISPLAY 'PROGRAMA EXECUTADO COM ERRO'                        00110700
           DISPLAY '    PARAGRAFO     = ' WRK-PARAGRAFO.                00110800
           DISPLAY '    FILE-STATUS   = ' WRK-FILE-STATUS.              00110900
           DISPLAY '    NOME-ARQUIVO  = ' WRK-NOME-ARQUIVO.             00111000
           DISPLAY '    COMANDO       = ' WRK-COMANDO.                  00111100
           DISPLAY '    LOCAL         = ' WRK-LOCAL.                    00111200
                                                                        00111300
           PERFORM 9999-API-ERROS.                                      00111400
                                                                        00111500
      *----------------------------------------------------------------*00111600
       9996-99-FIM.                    EXIT.                            00111700
      *----------------------------------------------------------------*00111800
                                                                        00111900
      ******************************************************************00112000
      *    ROTINA PARA ABENDAR O SISTEMA.                              *00112100
      ******************************************************************00112200
      *----------------------------------------------------------------*00112300
       9998-ROTINA-ABEND               SECTION.                         00112400
      *----------------------------------------------------------------*00112500
                                                                        00112600
           DISPLAY '*** BRAD0450 CHAMADO PARA ABENDAR O PROGRAMA ***'.  00112700
           DISPLAY ' '.                                                 00112800
                                                                        00112900
           CALL 'BRAD0450'             USING WRK-ABEND-0450             00113000
                                             WRK-DUMP-0450.             00113100
                                                                        00113200
      *----------------------------------------------------------------*00113300
       9998-99-FIM.                    EXIT.                            00113400
      *----------------------------------------------------------------*00113500
                                                                        00113600
      ******************************************************************00113700
      *    ROTINA PARA TRATAMENTO DE ERRO.                             *00113800
      ******************************************************************00113900
      *----------------------------------------------------------------*00114000
       9999-API-ERROS                  SECTION.                         00114100
      *----------------------------------------------------------------*00114200
                                                                        00114300
           IF  WRK-ABENDAR                                              00114400
               PERFORM 9998-ROTINA-ABEND                                00114500
           END-IF.                                                      00114600
                                                                        00114700
           STOP RUN.                                                    00114800
                                                                        00114900
      *----------------------------------------------------------------*00115000
       9999-99-FIM.                    EXIT.                            00115100
      *----------------------------------------------------------------*00115200
