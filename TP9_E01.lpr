program TP9_E01;

{Ej 1) Una empresa de transporte de encomiendas tiene un registro de los paquetes a transportar en un
archivo PAQUETES.DAT, de cada uno se conoce:
# CODIGO de PAQUETE
# PESO
# CODIGO de DESTINO (1..30)
# MONTO ASEGURADO
Por otro lado se cuenta con un archivo DESTINO.DAT que contiene:
# CODIGO de DESTINO (1..30, desordenado)
# DESCRIPCION (cadena de 15)
Se desea saber:
a) El peso promedio de los paquetes.
b) Total del monto asegurado de la carga a transportar.
c) Al finalizar el proceso armar el siguiente listado:
Destino Cantidad de Paquetes
Xxxxxxxxxxxxxxxx 99
. . . . . .
TOTAL 99 }

const
  CANT_DEST = 30;

type
  st5 = string[5];
  st15 = string[15];

  TRPaq = record
    codPaq: st5;
    peso, monto: real;
    codDest: byte;
  end;

  TRDest = record
    codDest: byte;
    descripcion: st15;
  end;

  TAPaq = file of TRPaq;
  TADest = file of TRDest;
  TV = array[1..CANT_DEST] of word;
  TVCad = array[1..CANT_DEST] of st15;

procedure cargaPaq(var archPaq: TAPaq);
var
  R: TRPaq;
  arch: text;
begin
  rewrite(archPaq);
  assign(arch, 'PAQ-1.TXT');
  reset(arch);
  while not eof(arch) do
    begin
      readln(arch, R.codPaq, R.peso, R.codDest, R.monto);
      write(archPaq, R);
    end;
  close(arch);
  close(archPaq);
end;

procedure cargaDest(var archDest: TADest);
var
  R: TRDest;
  arch: text;
begin
  rewrite(archDest);
  assign(arch, 'DEST-1.TXT');
  reset(arch);
  while not eof(arch) do
    begin
      readln(arch, R.codDest, R.descripcion);
      write(archDest, R);
    end;
  close(arch);
  close(archDest);
end;

procedure cargaTabla(var archDest: TADest; var tabla: TVCad);
var
  R: TRDest;
begin
  reset(archDest);
  while not eof(archDest) do
    begin
      read(archDest, R);
      tabla[R.codDest]:= R.descripcion;
    end;
  close(archDest);
end;

function pesoProm(var archPaq: TAPaq): real;
var
  R: TRPaq;
  sum: real;
  cont: byte;
begin
  sum:= 0;
  cont:= 0;
  reset(archPaq);
  while not eof(archPaq) do
    begin
      read(archPaq, R);
      sum:= sum + R.peso;
      cont:= cont + 1;
    end;
  if cont <> 0 then
    pesoProm:= sum / cont
  else
    pesoProm:= 0;
  close(archPaq);
end;

function montoTot(var archPaq: TAPaq): real;
var
  R: TRPaq;
  monto: real;
begin
  monto:= 0;
  reset(archPaq);
  while not eof(archPaq) do
    begin
      read(archPaq, R);
      monto:= monto + R.monto;
    end;
  montoTot:= monto;
  close(archPaq);
end;

procedure iniciaV(var vec: TV);
var
  i: byte;
begin
  for i:= 1 to CANT_DEST do
    vec[i]:= 0;
end;

procedure listado(tabla: TVCad; var archPaq: TAPaq);
var
  vec: TV;
  RPaq: TRPaq;
  tot: word;
  i: byte;
begin
  tot:= 0;
  iniciaV(vec);
  reset(archPaq);
  writeln('DESTINO      CANTIDAD DE PAQUETES');
  while not eof(archPaq) do
    begin
      read(archPaq, RPaq);
      vec[RPaq.codDest]:= vec[RPaq.codDest] + 1;
      tot:= tot + 1;
    end;
  for i:= 1 to CANT_DEST do
    writeln(tabla[i],'      ', vec[i]);
  writeln('Total: ', tot);
  close(archPaq);
end;

var
  archPaq: TAPaq;
  archDest: TADest;
  tabla: TVCad;

begin
  assign(archPaq, 'PAQUETES.DAT');
  assign(archDest, 'DESTINO.DAT');
  cargaPaq(archPaq);
  cargaDest(archDest);
  cargaTabla(archDest, tabla);
  writeln('Peso promedio: ', pesoProm(archPaq):5:2);
  writeln('Monto total: ', montoTot(archPaq):5:2);
  listado(tabla, archPaq);
  readln;
end.

