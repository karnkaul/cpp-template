#include <filesystem>
#include <iostream>
#include <sstream>
#include <string_view>
#include <version.hpp>

namespace {
std::ostream& format(std::ostream& out_str, std::string_view fmt) { return out_str << fmt; }

template <typename Arg0, typename... Args>
std::ostream& format(std::ostream& out_str, std::string_view fmt, Arg0 const& arg0, Args const&... args) {
	constexpr static std::string_view token = "{}";
	if (auto const search = fmt.find(token); search < fmt.size()) {
		out_str << fmt.substr(0, search) << arg0;
		return format(out_str, fmt.substr(search + token.size()), args...);
	} else {
		return format(out_str, fmt);
	}
}

template <typename... Args>
std::string format(std::string_view fmt, Args const&... args) {
	std::stringstream str;
	format(str, fmt, args...);
	return str.str();
}
} // namespace

int main(int argc, char const* const argv[]) {
	if (argc > 0) {
		std::string_view const argv0 = argv[0];
		auto const full_path = std::filesystem::absolute(argv0);
		if (std::filesystem::is_regular_file(full_path)) {
			std::cout << format("Executable located at: {}\nVersion: {}\n", full_path.generic_string(), cpp_template_version);
		} else {
			std::cerr << "Executable not found!\n";
		}
	}
}
