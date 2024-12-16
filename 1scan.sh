#!/bin/bash

# script1.sh: Escaneo inicial de rangos de IP

# Configuración
hilos=30
mazorca_dir="mazorca"
mkdir -p "$mazorca_dir"
resultados="$mazorca_dir/script_results"
progreso="$mazorca_dir/script_progress"

# Preguntar por el rango a escanear
echo -e "\033[1;34mSeleccione el rango que desea escanear:\033[0m"
echo "1. 10.0.0.0/8"
echo "2. 172.16.0.0/12"
echo "3. 192.168.0.0/16"
read -p "Ingrese su elección (1-3): " eleccion

case $eleccion in
1)
    base="10"
    inicio_i=0; fin_i=255
    inicio_j=0; fin_j=255
    total_rangos=$((256 * 256))
    rango_mensaje="$base.0.0.0/8"
    ;;
2)
    base="172"
    inicio_i=16; fin_i=31
    inicio_j=0; fin_j=255
    total_rangos=$((16 * 256))
    rango_mensaje="$base.16.0.0/12"
    ;;
3)
    base="192"
    inicio_i=168; fin_i=168
    inicio_j=0; fin_j=255
    total_rangos=256
    rango_mensaje="$base.168.0.0/16"
    ;;
*)
    echo "Opción inválida. Saliendo."
    exit 1
    ;;
esac

resultados="mazorca/script_results-$base"
mkdir -p "mazorca/loot"
resultados="$mazorca_dir/loot/script_results-$base"

trap "echo -e '\n\033[1;33m[+] Escaneo pausado. Puedes reanudarlo más tarde.\033[0m'; exit" SIGINT

# Recuperar progreso si existe
if [[ -f $progreso ]]; then
    ultimo_rango=$(cat "$progreso")
    echo -e "\033[1;33m[+] Continuando desde el rango $ultimo_rango...\033[0m"
    inicio_i=$(echo "$ultimo_rango" | cut -d '.' -f 2)
    inicio_j=$(echo "$ultimo_rango" | cut -d '.' -f 3)
else
    echo -e "\033[1;34m[+] Iniciando escaneo profundo en $rango_mensaje...\033[0m"
fi

# Escanear rangos
cont=0
for i in $(seq "$inicio_i" "$fin_i"); do
    for j in $(seq "$inicio_j" "$fin_j"); do
        rango="$base.$i.$j.0/24"
        echo "$rango" > "$progreso" # Guardar progreso
        porcentaje=$((++cont * 100 / total_rangos))
        echo -ne "\r\033[1;34m[*] Escaneando rango: $rango ($porcentaje% completado)\033[0m"

        (
            ips=$(seq -f "$base.$i.$j.%g" 1 5)
            echo "$ips" | fping -a -q 2>/dev/null | while read ip; do
                echo -e "\n\033[1;32m[+] IP viva encontrada: $ip en el rango $rango\033[0m"
                echo "Ip: $ip Rango: $rango" >> "$resultados"
            done
        ) &

        if (( cont % hilos == 0 )); then
            wait
        fi
    done
    inicio_j=0
done
wait

echo -e "\n\033[1;33m[+] Escaneo de rangos completado.\033[0m"
