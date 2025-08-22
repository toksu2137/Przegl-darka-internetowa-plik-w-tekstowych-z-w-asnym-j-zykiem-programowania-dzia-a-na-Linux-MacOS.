read -p "Podaj pełną ścieżkę do pliku tekstowego (.txt): " file_path

if [[ ! -f "$file_path" ]]; then
    echo "Plik '$file_path' nie istnieje."
    exit 1
fi

echo -e "\nOdczyt pliku: $file_path\n"

while IFS= read -r line; do
    line=$(echo "$line" | xargs)

    if [[ -z "$line" ]]; then
        continue
    fi

    if [[ "$line" =~ \<text\>(.*)\<t\> ]]; then
        text="${BASH_REMATCH[1]}"
        echo "$text"

    elif [[ "$line" =~ \<path\>(.*)\<p\> ]]; then
        path="${BASH_REMATCH[1]}"
        echo "Otwarcie ścieżki: $path"
        xdg-open "$path" 2>/dev/null || echo "Błąd otwierania ścieżki."

    elif [[ "$line" =~ \<run\>(.*)\<r\> ]]; then
        cmd="${BASH_REMATCH[1]}"
        echo "Uruchamianie: $cmd"
        eval "$cmd"

    else
        echo "Nieznane polecenie lub format: $line"
    fi
done < "$file_path"
