#include <netdb.h>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <fstream>
#include <unistd.h>
#include <arpa/inet.h>

using namespace std;

#define PUERTO "7200"
#define BACKLOG 100 // Peticiones pendientes
#define TAM_BUFFER 1024

// Obtiene la direccion IPv4 o IPv6
void *get_in_addr(struct sockaddr *sa) {
    if (sa->sa_family == AF_INET)
        return &(((struct sockaddr_in *)sa)->sin_addr);
    printf("%s\n", "ES IPv6");
    return &(((struct sockaddr_in6 *)sa)->sin6_addr);
}

int main(int argc, char const *argv[]) {
    int servidor_fd, cliente_fd; // servidor y cliente
    struct sockaddr_storage cliente_addr; // info cliente
    socklen_t sin_size;
    int yes = 1;
    char s[INET_ADDRSTRLEN];
    unsigned char buffer[TAM_BUFFER];
    int rv;
    struct addrinfo hints, *servidor_info, *p;
    int num_bytes;

    memset(&buffer, 0, TAM_BUFFER);
    memset(&s, 0, INET_ADDRSTRLEN);
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE; // Usar mi IP


    if ((rv = getaddrinfo(NULL, PUERTO, &hints, &servidor_info)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // Itera hasta encontrar
    for(p = servidor_info; p != NULL; p = p->ai_next) {
        // Creando el descriptor de archivo del socket
        if ((servidor_fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("server: socket");
            continue;
        }
        
        if (setsockopt(servidor_fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
            perror("server: setsockopt");
            exit(EXIT_FAILURE);
        }
        // Ligar el socket al puerto
        if (bind(servidor_fd, p->ai_addr, p->ai_addrlen) == -1) {
            close(servidor_fd);
            perror("server: bind");
            continue;
        }
        break;
    }
    freeaddrinfo(servidor_info); // Ya no se ocupa

    if (p == NULL)  {
        fprintf(stderr, "server: error en bind\n");
        exit(EXIT_FAILURE);
    }

    if (listen(servidor_fd, BACKLOG) == -1) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    unsigned short dato = 0;
    while (true) {
        sin_size = sizeof(cliente_addr);
        printf("%s\n", "Esperando...");
        cliente_fd = accept(servidor_fd, (struct sockaddr *)&cliente_addr, &sin_size);
        if (cliente_fd == -1) {
            perror("accept");
            continue;
        }

        inet_ntop(AF_INET, &(((struct sockaddr_in *)&cliente_addr)->sin_addr), s, INET_ADDRSTRLEN);
        printf("%s %s\n", "Conexion desde: ", s);
        memset(&s, 0, INET_ADDRSTRLEN);
        num_bytes = read(cliente_fd, buffer, TAM_BUFFER);
        printf("%s %d %s %s\n", "Leidos: ", num_bytes, "buffer: ", buffer);
        if (num_bytes) {
            ofstream archivo("muestras2.txt");
            if (archivo.is_open()) {
                printf("%s\n", "Archivo abierto!");
                for (int i = 0; i < TAM_BUFFER; i++) {
                    if (buffer[i] & 0x0080) {
                        dato |= (buffer[i] & 0x003F) << 6;
                        archivo << (3.3 * dato) /4095 << endl;
                        dato = 0;
                    } else
                        dato = buffer[i] & 0x3F;
                }
                archivo.close();
                printf("%s\n", "Archivo cerrado!");
            }
        }
        close(cliente_fd);
    }

    return 0;
}
