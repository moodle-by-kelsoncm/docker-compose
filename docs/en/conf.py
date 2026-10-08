import moodle_docs_theme

project = "moodle-docker-compose"
copyright = "2026, Kelson da Costa Medeiros"
author = "Kelson da Costa Medeiros"
release = "5.3.0"

extensions = [
    "sphinx.ext.githubpages",
    "moodle_docs_theme",
]

templates_path = []
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

language = "en"

html_theme = "moodle_docs_theme"
html_theme_path = [moodle_docs_theme.get_html_theme_path()]

html_theme_options = {
    "project_name": "moodle-docker-compose",
    "tagline": "Containerized Docker Compose environment for Moodle development",
    "github_url": "https://github.com/moodle-by-kelsoncm/docker-compose",
    "github_repo": "moodle-by-kelsoncm/docker-compose",
    "github_version": "MOODLE_503",
    "doc_path": "docs/en/",
    "show_edit_on_github": True,
    "enable_dark_mode": True,
    "enable_language_selector": True,
    "navigation_links": "Home|index, Installation|installation, Configuration|configuration, Usage|usage",
}

html_static_path = []
