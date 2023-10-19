#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <cstring>
#include <arpa/inet.h>
#include <unistd.h>
#include <thread>
#include "logger_manager.h"
#include <fstream>
#include <sstream>
#include <ctime>
#include <string>
#include <mutex>
#include <sys/stat.h>
#include <cstdlib>

logger_manager::logger_manager() {}
logger_manager::~logger_manager() {}
logger_manager logManager;

// global variable for print log
int c_Port[100000];

// get Date data
std::string GetTodayDate() {
	time_t now = time(0);
	struct tm today;
	localtime_r(&now, &today);

	char buffer[11];
	strftime(buffer, sizeof(buffer), "%Y-%m-%d", &today);

	return buffer;
}

// check duplication of directory and create directory
bool createLogDirectory(const std::string& logDirectory) {
	if(mkdir(logDirectory.c_str(), 0777) == 0) {
		return true; // success
	} else if(errno == EEXIST) {
		return true; // exist
	} else {
		return false; // error
	}
}

// Logging
const char* datatime_now() {
	time_t now = time(0);
	struct tm today;
	localtime_r(&now, &today);

	static char buffer[20];
	strftime(buffer, sizeof(buffer), "%y-%m-%d %H:%M:%S", &today); // formatting to "yyyy-mm-dd hh:mm:ss"

	return buffer;
}

void logger_manager::write(const std::string& pgmname, const std::string& msg) {
	std::mutex mtx;
	const std::lock_guard<std::mutex> lock(mtx);
	
	if(!createLogDirectory("./logs")) {
		std::cerr << "Err creating log directory" << std::endl;
	}

	std::string logFileName = "./logs/log-" + GetTodayDate();
	std::string data_time = datatime_now();
	std::string log_file_name = logFileName + ".log";
	std::string message = data_time + " " + msg + "\n";

	output_to_file(log_file_name, message);
}

void logger_manager::output_to_file(const std::string& file_name, const std::string& msg) {
	std::ofstream ofs(file_name.c_str(), std::ios::out | std::ios::app);
	if(ofs.fail()) {
		std::cerr << file_name << "couldn't open file!!" << std::endl;
		throw std::ios_base::failure("logger_manager::write - " + file_name);
	}
	ofs << msg;
	ofs.clear();
	ofs.close();
}

void handleClient(int clientSocket) {
    char buffer[1024];
    while (true) {
        memset(buffer, 0, sizeof(buffer));
        int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);

		// random failed to receive message from client
		if(std::rand() % 10 == 0) {
			logManager.write(__FILE__, "[INFO] Message receive failed for client " + std::to_string(c_Port[clientSocket]));
			std::cerr << "Message receive failed for client." << std::endl;
			continue;
		}

        if (bytesRead == -1) {
            std::cerr << "Error receiving data from client" << std::endl;
            break;
        } else if (bytesRead == 0) {
            // Client disconnected
            std::cout << "Client disconnected" << std::endl;
			logManager.write(__FILE__, "[INFO] Client disconnected from " + std::to_string(c_Port[clientSocket]));
            break;
        } else {
            std::cout << "Received from client: " << buffer << std::endl;
			logManager.write(__FILE__, "[INFO] [" + std::to_string(c_Port[clientSocket]) + "] " + buffer);
        }
    }
    close(clientSocket);
}

int sock, csock;
struct sockaddr_in serverAddress;
int opt = 1;
int addrlen = sizeof(serverAddress);
int init_sock(){	

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        std::cerr << "Error creating socket\n" << std::endl;
        return -1;
    }

    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(8082);
    serverAddress.sin_addr.s_addr = INADDR_ANY;

    if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
        std::cerr << "Error setting socket options\n" << std::endl;
        close(sock);
        return -1;
    }

    if (bind(sock, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) == -1) {
		logManager.write(__FILE__, "[Err] Error binding socket");
        std::cerr << "Error binding socket\n" << std::endl;
        close(sock);
        return -1;
    }

    if (listen(sock, 5) == -1) {
        std::cerr << "Error listening on socket\n" << std::endl;
        close(sock);
        return -1;
    }	
    std::cout << "Server listening on port 8081..." << std::endl;
	
	return 0;
}

int main() {
	// Logging
	logManager.write(__FILE__, "[INFO] server.cc starting...");
	logManager.write(__FILE__, "[INFO] Server listening on port 8082 --> Server start" );
	char clientAddress[INET_ADDRSTRLEN]; // client Address

	// print error of init_socket()
	if( init_sock() == -1){
		logManager.write(__FILE__, "[Err] Error init_socket()");
		std::cerr << "Error init_socket()\n" << std::endl;
		return -1;
	}

    while (true) {
        if ((csock = accept(sock, (struct sockaddr *)&serverAddress, (socklen_t *)&addrlen)) < 0) {
            std::cerr << "Error accepting client connection\n" << std::endl;
			logManager.write(__FILE__, "[ERR] Error accepting client connection");
        } else {
			if(inet_ntop(AF_INET, &serverAddress.sin_addr, clientAddress, INET_ADDRSTRLEN) != NULL) {
				int clientPort = ntohs(serverAddress.sin_port);
				c_Port[csock] = ntohs(serverAddress.sin_port); // global client port number for print log
				std::cout << "New client connected from " << clientAddress << ": " << clientPort << std::endl;
				logManager.write(__FILE__, "[INFO] New client connected from " + std::string(clientAddress) + ": " + std::to_string(clientPort));
			}

            // recv msg
            std::thread(handleClient, csock).detach();
        }
    }

    close(sock);

    return 0;
}

