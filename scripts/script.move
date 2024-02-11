script {
    use std::string;
    use std::debug;

    fun main() {
        debug::print(&string::utf8(b"this is a script, indeed"));
    }
}
