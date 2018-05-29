#include <stdio.h>
#include <netdb.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <cstring>
#include <unistd.h>

#define PUERTO "7200"
#define BACKLOG 100 // Peticiones pendientes
#define TAM_BUFFER 1

// Obtiene la direccion IPv4 o IPv6
void *get_in_addr(struct sockaddr *sa) {
    if (sa->sa_family == AF_INET)
        return &(((struct sockaddr_in *)sa)->sin_addr);
    return &(((struct sockaddr_in6 *)sa)->sin6_addr);
}

int main(int argc, char const *argv[]) {
    int sockfd, new_fd; // servidor y cliente
    struct sockaddr_storage their_addr; // connector's address information
    socklen_t sin_size;
    int yes = 1;
    char s[INET6_ADDRSTRLEN];
    unsigned char buffer[TAM_BUFFER];
    int rv;
    struct addrinfo hints, *servinfo, *p;
    int numbytes;

    memset(&buffer, 0, TAM_BUFFER);
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE; // Usar mi IP


    if ((rv = getaddrinfo(NULL, PUERTO, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // Itera hasta encontrar
    for(p = servinfo; p != NULL; p = p->ai_next) {
        // Creando el descriptor de archivo del socket
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("server: socket");
            continue;
        }
        
        if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
            perror("setsockopt");
            exit(EXIT_FAILURE);
        }
        // Ligar el socket al puerto
        if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            perror("server: bind");
            continue;
        }
        break;
    }
    freeaddrinfo(servinfo); // Ya no se ocupa

    if (p == NULL)  {
        fprintf(stderr, "server: failed to bind\n");
        exit(EXIT_FAILURE);
    }

    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("%s\n", "Esperando...");

    while (true) {
        sin_size = sizeof(their_addr);
        new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
        if (new_fd == -1) {
            perror("accept");
            continue;
        }

        inet_ntop(their_addr.ss_family, get_in_addr((struct sockaddr *)&their_addr), s, sizeof(s));
        printf("%s %s\n", "server: got connection from ", s);
        numbytes = read(new_fd, buffer, TAM_BUFFER);
        printf("LEIDOS %d, BUFFER: %s\n", numbytes, buffer);
        close(new_fd);
    }

    return 0;
}