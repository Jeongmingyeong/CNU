#include <string>
#include <ostream>

// -------------------삭제 가능
enum LOG_LEVEL {
    LOG_LEVEL_NONE
    , LOG_LEVEL_DEBUG
    , LOG_LEVEL_INFORM
    , LOG_LEVEL_WARNING
    , LOG_LEVEL_ERROR
};
const std::string LOG_DESC[] {
    "DEBUG"
    , "INFO"
    , "WARN"
    , "ERR"
};
// -------------------삭제 가능

class logger_manager{
public:
    logger_manager();
    ~logger_manager();   
    static void write(const std::string& pgmname, const std::string& msg);

private:    
    static void output_to_file(const std::string& file_name, const std::string& msg);

    logger_manager(const logger_manager &) = delete;
    logger_manager& operator=(const logger_manager &) = delete;
};