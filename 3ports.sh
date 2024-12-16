#!/bin/bash

# ports1.sh: Escaneo de puertos en IPs vivas

# Configuración inicial
mazorca_dir="mazorca"
loot_dir="$mazorca_dir/loot"
mkdir -p "$mazorca_dir"
mkdir -p "$loot_dir"

# Detectar el archivo de IPs vivas según el rango
read -p "Ingrese la base del rango escaneado (10, 172 o 192): " base
ips_vivas="$loot_dir/script_IPs_vivas-$base"
escaneo_puertos="$loot_dir/script_escaneo_puertos-$base"
puertos="21 23 25 79 80 88 135 443 445 873 2375 2376 2049 5985 5986 8080 8081 8088 10000"
hilos=10

# Verificar si el archivo de IPs vivas existe
if [[ ! -f $ips_vivas ]]; then
    echo -e "\033[1;31m[!] No se encontró el archivo $ips_vivas. Ejecuta primero rangos1.sh.\033[0m"
    exit 1
fi

# Escaneo de puertos
echo -e "\033[1;34m[+] Iniciando escaneo de puertos en IPs vivas desde $ips_vivas...\033[0m"

cont=0
while read -r ip; do
    (
        for puerto in $puertos; do
            nc -z -w1 "$ip" "$puerto" 2>/dev/null && echo "$ip:$puerto" >> "$escaneo_puertos"
        done
    ) &
    ((cont++))
    if (( cont % hilos == 0 )); then
        wait
    fi
done < "$ips_vivas"
wait

echo -e "\033[1;33m[+] Escaneo de puertos completado. Resultados guardados en $escaneo_puertos.\033[0m"
