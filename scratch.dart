import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'C:\Users\SAKSHI\.gemini\antigravity-ide\brain\2107da32-84ca-4e51-82b2-c3ddceaf8c35\.system_generated\steps\153\content.md');
  final text = file.readAsStringSync().split('---').last.trim();
  final json = jsonDecode(text) as List<dynamic>;
  
  int totalRepos = json.length;
  Map<String, int> langCounts = {};
  
  for (var repo in json) {
    if (repo['language'] != null) {
      String lang = repo['language'];
      langCounts[lang] = (langCounts[lang] ?? 0) + 1;
    }
  }
  
  print('Total Repos: $totalRepos');
  print('Languages: $langCounts');
}
