# Inception-Projekt

Dieses Projekt ist eine Einführung in die Systemadministration und Docker. Ziel ist es, eine Infrastruktur aus mehreren Docker-Containern (NGINX, WordPress, MariaDB und weiteren Bonus-Diensten) mithilfe von `docker-compose` zu erstellen und zu verwalten.

## Inhaltsverzeichnis

- [Über das Projekt](#über-das-projekt)
  - [Architektur](#architektur)
  - [Technologien](#technologien)
- [Erste Schritte](#erste-schritte)
  - [Voraussetzungen](#voraussetzungen)
  - [Installation](#installation)
- [Verwendung](#verwendung)
- [Dienste](#dienste)
  - [NGINX](#nginx)
  - [WordPress](#wordpress)
  - [MariaDB](#mariadb)
  - [Bonus-Dienste](#bonus-dienste)
- [Netzwerk und Volumes](#netzwerk-und-volumes)

---

## Über das Projekt

Dieses Projekt richtet eine vollständige Webanwendungsumgebung ein, die vollständig in Docker-Containern läuft. Es demonstriert das Verständnis von Docker-Images, Containern, Netzwerken, Volumes und der Automatisierung mit `docker-compose` und einem `Makefile`.

### Architektur

Die Architektur ist um einen NGINX-Webserver als zentralen Einstiegspunkt herum aufgebaut.

-   **NGINX** dient als Reverse-Proxy und Webserver. Es verarbeitet alle eingehenden Anfragen auf Port 443 (HTTPS) und leitet sie an die entsprechenden Dienste weiter.
-   **WordPress** ist das Content-Management-System (CMS). Es läuft als eigenständiger Dienst mit PHP-FPM und kommuniziert mit der MariaDB-Datenbank.
-   **MariaDB** ist die relationale Datenbank, die alle WordPress-Daten wie Beiträge, Benutzer und Einstellungen speichert.
-   **Redis** (Bonus) wird als In-Memory-Cache für WordPress verwendet, um die Leistung durch Caching von Objekten zu beschleunigen.
-   **Hugo** & **Static Page** (Bonus) sind zwei separate, mit Hugo erstellte statische Websites, die über die Endpunkte `/me` und `/static` von NGINX bereitgestellt werden.

Alle Dienste kommunizieren über ein benutzerdefiniertes Bridge-Netzwerk namens `inception_net`.

### Technologien

-   **Docker & Docker Compose**: Zum Erstellen und Verwalten der containerisierten Umgebung.
-   **Alpine Linux**: Als leichtgewichtiges Basis-Image für alle Dienste, um die Größe der Images minimal zu halten.
-   **NGINX**: Als Webserver und Reverse-Proxy.
-   **WordPress**: Mit `wp-cli` für die automatisierte Installation und Konfiguration.
-   **MariaDB**: Als Datenbank für WordPress.
-   **Redis**: Für das Caching.
-   **Hugo**: Ein Generator für statische Websites für die Bonus-Teile.

---

## Erste Schritte

Folgen Sie diesen Schritten, um das Projekt lokal einzurichten und auszuführen.

### Voraussetzungen

-   **Docker** und **Docker Compose** müssen installiert sein.
-   Sie benötigen `sudo`-Rechte, um Docker-Befehle auszuführen und Volumes zu verwalten.
-   Zugriff zum Bearbeiten der `/etc/hosts`-Datei.

### Installation

1.  **Repository klonen**
    ```sh
    git clone [https://github.com/mwagner86/inception.git](https://github.com/mwagner86/inception.git)
    cd inception
    ```

2.  **Host-Datei bearbeiten**
    Fügen Sie die folgende Zeile zu Ihrer `/etc/hosts`-Datei hinzu, um die Domain auf Ihre lokale Maschine zu leiten:
    ```sh
    127.0.0.1 mwagner.42.fr
    ```
    Dies wird durch den `make`-Befehl `add_unix_entry` automatisiert.

3.  **.env-Datei erstellen**
    Erstellen Sie eine `.env`-Datei im `srcs`-Verzeichnis. Diese Datei wird von `docker-compose` verwendet, um Umgebungsvariablen für die Dienste zu laden. Füllen Sie sie mit den erforderlichen Werten (Datenbank-Anmeldeinformationen, WordPress-Details usw.).

4.  **Projekt erstellen und starten**
    Führen Sie den folgenden Befehl im Stammverzeichnis des Projekts aus:
    ```sh
    make all
    ```
    Dieser Befehl wird:
    -   Die notwendigen Verzeichnisse für die Volumes erstellen (`/home/max/data/...`).
    -   Die Docker-Images für jeden Dienst erstellen.
    -   Die Container im Hintergrund starten (`-d`).

---

## Verwendung

Das Projekt wird vollständig über das `Makefile` gesteuert. Hier sind die wichtigsten Befehle:

-   `make all`: Erstellt die Volumes, fügt den Host-Eintrag hinzu und startet alle Dienste.
-   `make up`: Startet die Dienste mit `docker-compose up --build -d`.
-   `make down`: Stoppt alle laufenden Dienste.
-   `make fclean`: Stoppt die Dienste und löscht die Daten-Volumes.
-   `make re`: Führt einen `fclean` und dann `all` aus, um das Projekt vollständig neu zu erstellen.
-   `make prune`: Entfernt alle ungenutzten Docker-Objekte (Container, Netzwerke, Images, Volumes), um Speicherplatz freizugeben.
-   `make logs`: Zeigt die Logs aller laufenden Dienste an.

---

## Dienste

### NGINX

-   **Dockerfile**: `srcs/requirements/nginx/Dockerfile`
-   **Konfiguration**: `srcs/requirements/nginx/conf/nginx.conf`
-   **Funktionen**:
    -   Basiert auf Alpine Linux.
    -   Stellt den gesamten Traffic über **HTTPS (Port 443)** bereit.
    -   Generiert ein **selbstsigniertes SSL-Zertifikat** für `mwagner.42.fr`.
    -   Leitet PHP-Anfragen an den WordPress-Container (`wordpress:9000`) weiter.
    -   Fungiert als Reverse-Proxy für die Bonus-Dienste:
        -   Anfragen an `/me` werden an `http://hugo:1313/me` weitergeleitet.
        -   Anfragen an `/static` werden an `http://static_page:1313/static` weitergeleitet.

### WordPress

-   **Dockerfile**: `srcs/requirements/wordpress/Dockerfile`
-   **Konfiguration**: `srcs/requirements/wordpress/tools/tool.sh`
-   **Funktionen**:
    -   Basiert auf Alpine Linux mit PHP 8.1.
    -   Verwendet `wp-cli`, um WordPress bei der ersten Ausführung automatisch herunterzuladen, zu konfigurieren und zu installieren.
    -   Verbindet sich mit der MariaDB-Datenbank über den Hostnamen `mariadb`.
    -   Integriert **Redis-Caching** durch Installation und Aktivierung des `redis-cache`-Plugins.
    -   Installiert und aktiviert das 'twentysixteen'-Theme.
    -   Erstellt einen Administrator und einen weiteren Benutzer.

### MariaDB

-   **Dockerfile**: `srcs/requirements/mariadb/Dockerfile`
-   **Konfiguration**: `srcs/requirements/mariadb/tools/maria_setup.sh`, `srcs/requirements/mariadb/conf/db_create.sql`
-   **Funktionen**:
    -   Basiert auf Alpine Linux.
    -   Initialisiert bei der ersten Ausführung die Datenbank und erstellt den WordPress-Benutzer und die Datenbank basierend auf den `.env`-Variablen.
    -   Daten werden persistent in einem Volume gespeichert, das an `/var/lib/mysql` gebunden ist.

### Bonus-Dienste

1.  **Redis**
    -   **Dockerfile**: `srcs/requirements/bonus/redis/Dockerfile`
    -   Ein In-Memory-Cache, der die Datenbankabfragen von WordPress reduziert und so die Ladezeiten verbessert.

2.  **Hugo Static Site (`/me`)**
    -   **Dockerfile**: `srcs/requirements/bonus/hugo/Dockerfile`
    -   Eine einfache persönliche Website, die mit Hugo erstellt wurde. Erreichbar unter `https://mwagner.42.fr/me`.

3.  **Static Page (`/static`)**
    -   **Dockerfile**: `srcs/requirements/bonus/static_page/Dockerfile`
    -   Eine weitere statische Website, die Markdown-Formatierung und eine "Über mich"-Seite zeigt. Erreichbar unter `https://mwagner.42.fr/static`.

---

## Netzwerk und Volumes

-   **Netzwerk**: Alle Container sind mit einem benutzerdefinierten Bridge-Netzwerk namens `inception_net` verbunden. Dies ermöglicht die Kommunikation zwischen den Containern über ihre Dienstnamen (z. B. `wordpress`, `mariadb`).
-   **Volumes**: Um die Daten dauerhaft zu speichern, werden benannte Volumes verwendet:
    -   `mariadb`: Bindet das Host-Verzeichnis `/home/max/data/mariadb` an `/var/lib/mysql` im MariaDB-Container.
    -   `wordpress`: Bindet `/home/max/data/wordpress` an `/var/www/wordpress` im WordPress- und NGINX-Container, um die WordPress-Dateien persistent zu machen und für NGINX zugänglich zu machen.

