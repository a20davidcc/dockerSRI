# Instalación de zonas mestras primarias.

### 1. Comprobación do funcionamento do DNS.
Para comprobar que o noso DNS funciona correctamente executamos o seguinte comando.
```bash
dig @localhost www.edu.xunta.gal
```
A salida que obtuvemos de este comando é a seguinte.

![edu.xunta.gal](./img/captura1.png)

Como podemos ver na imaxe, resólveo perfectamente, xa que como nos indica, estamos tendo 1 resposta de 1 consulta que fixemos, ademáis devolve un rexistro tipo A coa IP 85.91.64.65 para www.edu.xunta.gal.


### 2. Configuración de reenviadores.
Para engadir reenviadores ao noso servidor BIND9 teremos que modificar o ficheiro  `named.conf.options`. Neste ficheiro encontraremos un apartado de forwarders que por defecto aparece comentado, teremos que descomentalo eliminando as // do principio da línea e configurar o noso reenviador. 
O ficheiro quedará da seguinte maneira:
```
options {
	directory "/var/cache/bind";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the addresses replacing 
	// the all-0's placeholder.

	 forwarders {
	 	8.8.8.8;
	 };

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	dnssec-validation auto;

	listen-on-v6 { any; };
};
```
Para comprobar que esto está funcionando correctamente executaremos este comando:
```
dig @localhost www.med.gob.es
```

Esta é a salida que nos mostra:
![med.gob.es](./img/captura2.png)


### 3. Instalación da zona primaria directa e creación de rexistros
O primeiro que temos que facer é crear a zona nun ficheiro chamado `/etc/bind/named.conf.local`. O ficheiro quedará da seguinte forma:
```
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "starwars.lan" {
    type master;
    file "/etc/bind/db.starwars";
};
```
Como vemos, estamos configurando unha zona chamada *starwars.lan*, que é de tipo máster e que ten como ficheiro `/etc/bind/db.starwars`. Este ficheiro actualmente non existe polo que temos que crealo.
Para iso, podemos copialo a partir dun ficheiro sí existente, o ficheiro `/etc/bind/db.local`. Para copialo executaremos esto:
```
cp /etc/bind/db.local /etc/bind/db.starwars
```
A partir de aquí xa podemos comenzar a editalo. O ficheiro quedará da seguinte maneira:
```
;
; BIND data file for local loopback interface
;
$TTL 604800
@   IN  SOA darthvader.starwars.lan. admin.starwars.lan. (
            2       ; Serial
            604800  ; Refresh
            86400   ; Retry
            2419200 ; Expire
            120 )   ; Negative Cache TTL

; Hosts Tipo NS
@   IN  NS  darthvader
@   IN  NS  darthsidious

; Hosts Tipo A
darthvader   IN  A   192.168.20.10
skywalker    IN  A   192.168.20.101
skywalker    IN  A   192.168.20.111
luke         IN  A   192.168.20.22
darthsidious IN  A   192.168.20.11
yoda         IN  A   192.168.20.24
yoda         IN  A   192.168.20.25
c3p0         IN  A   192.168.20.26

; Hosts Tipo CNAME
palpatine    IN  CNAME darthsidious

; Hosts Tipo MX
@   IN  MX  10  c3p0

; Hosts Tipo TXT
lenda        IN  TXT "Que a forza te acompañe"
```

### 4. Instalación da zona primaria inversa e creación de rexistros
