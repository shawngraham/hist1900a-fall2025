// Simple client-side search replacement for Algolia DocSearch
// Requires Fuse.js to be loaded first

class LocalSearch {
  constructor(options = {}) {
    this.container = options.container || '#docsearch';
    this.indexUrl = options.indexUrl || '/index.json';
    this.placeholder = options.placeholder || 'Search docs...';
    this.fuseOptions = {
      keys: [
  { name: 'title', weight: 0.8 },
  { name: 'content', weight: 0.4 },
  { name: 'summary', weight: 0.6 },
  { name: 'tags', weight: 0.3 },
  { name: 'categories', weight: 0.3 },
  { name: 'headings', weight: 0.5 }
],
      threshold: 0.3,
      includeScore: true,
      includeMatches: true,
      ...options.fuseOptions
    };
    
    this.searchIndex = null;
    this.fuse = null;
    this.isOpen = false;
    
    this.init();
  }

  async init() {
    await this.loadSearchIndex();
    this.createSearchInterface();
    this.bindEvents();
  }

  async loadSearchIndex() {
    try {
      const response = await fetch(this.indexUrl);
      this.searchIndex = await response.json();
      this.fuse = new Fuse(this.searchIndex, this.fuseOptions);
    } catch (error) {
      console.error('Failed to load search index:', error);
    }
  }

  createSearchInterface() {
    const container = document.querySelector(this.container);
    if (!container) return;

    // Create the search button first (this might already exist)
    if (!container.querySelector('.DocSearch-Button')) {
      container.innerHTML = `
        <div class="DocSearch DocSearch-Button" role="button" tabindex="0">
          <span class="DocSearch-Button-Container">
            <svg class="DocSearch-Search-Icon" width="20" height="20" viewBox="0 0 20 20">
              <path d="m17.5 17.5-5.25-5.25" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
              <circle cx="9" cy="9" r="7.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="DocSearch-Button-Placeholder">${this.placeholder}</span>
          </span>
          <span class="DocSearch-Button-Keys">
            <kbd class="DocSearch-Button-Key">⌘</kbd>
            <kbd class="DocSearch-Button-Key">K</kbd>
          </span>
        </div>
      `;
    }
    
    // Create the modal structure in body (like original DocSearch)
    if (!document.querySelector('.DocSearch-Container')) {
      document.body.insertAdjacentHTML('beforeend', `
        <div class="DocSearch-Container DocSearch-Container--Stalled">
          <div class="DocSearch-Modal">
            <header class="DocSearch-SearchBar">
              <form class="DocSearch-Form" role="search">
                <label class="DocSearch-MagnifierLabel">
                  <svg class="DocSearch-Search-Icon" width="20" height="20" viewBox="0 0 20 20">
                    <path d="m17.5 17.5-5.25-5.25" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                    <circle cx="9" cy="9" r="7.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </label>
                <div class="DocSearch-LoadingIndicator">
                  <svg width="20" height="20" viewBox="0 0 38 38" stroke="currentColor">
                    <g fill="none" fill-rule="evenodd">
                      <g transform="translate(1 1)" stroke-width="2">
                        <circle stroke-opacity=".5" cx="18" cy="18" r="18"/>
                        <path d="M36 18c0-9.94-8.06-18-18-18">
                          <animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="1s" repeatCount="indefinite"/>
                        </path>
                      </g>
                    </g>
                  </svg>
                </div>
                <input class="DocSearch-Input" type="search" placeholder="${this.placeholder}" maxlength="64" aria-autocomplete="both" aria-labelledby="docsearch-label" autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false">
                <button type="reset" class="DocSearch-Reset" hidden>
                  <svg width="20" height="20" viewBox="0 0 20 20">
                    <path d="m13 13-6-6m0 6 6-6" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
              </form>
              <button class="DocSearch-Cancel">Cancel</button>
            </header>
            
            <div class="DocSearch-Dropdown">
              <div class="DocSearch-Dropdown-Container">
                <section class="DocSearch-NoResults" style="display: none;">
                  <div class="DocSearch-Screen-Icon">
                    <svg width="40" height="40" viewBox="0 0 20 20" fill="none" stroke="currentColor">
                      <path d="M15.5 4.8c2 3 1.7 7-1 9.7h0l4.3 4.3-4.3-4.3a7.8 7.8 0 01-9.8 1m-2.2-2.2A7.8 7.8 0 0113.2 2.4M2 18L18 2"/>
                    </svg>
                  </div>
                  <p class="DocSearch-Title">No results for "<strong class="DocSearch-NoResults-Query"></strong>"</p>
                </section>
                <div class="DocSearch-Hits"></div>
              </div>
            </div>
            
            <footer class="DocSearch-Footer">
              <ul class="DocSearch-Commands">
                <li>
                  <kbd class="DocSearch-Commands-Key">
                    <svg width="15" height="15">
                      <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2">
                        <path d="M12 3.53088v3c0 1-1 2-2 2H4M7 11.53088l-3-3 3-3"/>
                      </g>
                    </svg>
                  </kbd>
                  <span class="DocSearch-Label">to select</span>
                </li>
                <li>
                  <kbd class="DocSearch-Commands-Key">
                    <svg width="15" height="15">
                      <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2">
                        <path d="M7.5 3.5v8M10.5 8.5l-3 3-3-3"/>
                      </g>
                    </svg>
                  </kbd>
                  <kbd class="DocSearch-Commands-Key">
                    <svg width="15" height="15">
                      <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2">
                        <path d="M7.5 11.5v-8M10.5 6.5l-3-3-3 3"/>
                      </g>
                    </svg>
                  </kbd>
                  <span class="DocSearch-Label">to navigate</span>
                </li>
                <li>
                  <kbd class="DocSearch-Commands-Key">
                    <svg width="15" height="15">
                      <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2">
                        <path d="M13.6167 8.936c-.1065.3583-.6883.962-1.4875.962-.7993 0-1.653-.9165-1.653-2.1258v-.5678c0-1.2548.7896-2.1016 1.653-2.1016.8634 0 1.3601.4778 1.4875 1.0724M9 6c-.1352-.4735-.7506-.9219-1.46-.8972-.7092.0246-1.344.57-1.344 1.2166s.4198.8812 1.3445.9805C8.465 7.3992 8.968 7.9337 9 8.5c.032.5663-.454 1.398-1.4595 1.398C6.6593 9.898 6 9 5.963 8.4851m-1.4748.5368c-.2635.5941-.8099.876-1.5443.876s-1.7073-.6248-1.7073-2.204v-.4603c0-1.0416.721-2.131 1.7073-2.131.9864 0 1.6425 1.031 1.5443 2.2492h-2.956"/>
                      </g>
                    </svg>
                  </kbd>
                  <span class="DocSearch-Label">to close</span>
                </li>
              </ul>
            </footer>
          </div>
        </div>
      `);
    }
  }

  bindEvents() {
    const button = document.querySelector('.DocSearch-Button');
    const modal = document.querySelector('.DocSearch-Modal');
    const container = document.querySelector('.DocSearch-Container');
    const input = document.querySelector('.DocSearch-Input');
    const cancelBtn = document.querySelector('.DocSearch-Cancel');
    const resetBtn = document.querySelector('.DocSearch-Reset');
    const form = document.querySelector('.DocSearch-Form');

    // Open search
    button?.addEventListener('click', () => this.openSearch());
    
    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        this.openSearch();
      }
      if (e.key === 'Escape' && this.isOpen) {
        this.closeSearch();
      }
    });

    // Close search
    cancelBtn?.addEventListener('click', () => this.closeSearch());
    container?.addEventListener('click', (e) => {
      if (e.target === container) this.closeSearch();
    });

    // Search input
    input?.addEventListener('input', (e) => this.performSearch(e.target.value));
    
    // Reset
    resetBtn?.addEventListener('click', () => {
      input.value = '';
      this.clearResults();
      resetBtn.hidden = true;
    });

    // Form submission
    form?.addEventListener('submit', (e) => e.preventDefault());
  }

  openSearch() {
    this.isOpen = true;
    const container = document.querySelector('.DocSearch-Container');
    const input = document.querySelector('.DocSearch-Input');
    
    if (container) {
      container.style.display = 'block';
      // Add the active class that CSS expects
      document.body.classList.add('DocSearch--active');
      container.classList.remove('DocSearch-Container--Stalled');
      input?.focus();
    }
  }

  closeSearch() {
    this.isOpen = false;
    const container = document.querySelector('.DocSearch-Container');
    
    if (container) {
      container.style.display = 'none';
      document.body.classList.remove('DocSearch--active');
      container.classList.add('DocSearch-Container--Stalled');
    }
  }

  performSearch(query) {
    const resetBtn = document.querySelector('.DocSearch-Reset');
    const noResults = document.querySelector('.DocSearch-NoResults');
    const hits = document.querySelector('.DocSearch-Hits');
    
    // Show/hide reset button
    if (resetBtn) {
      resetBtn.hidden = !query;
    }

    if (!query || !this.fuse) {
      this.clearResults();
      return;
    }

    const results = this.fuse.search(query);
    
    if (results.length === 0) {
      this.showNoResults(query);
    } else {
      this.showResults(results);
    }
  }

  showResults(results) {
    const noResults = document.querySelector('.DocSearch-NoResults');
    const hits = document.querySelector('.DocSearch-Hits');
    
    if (noResults) noResults.style.display = 'none';
    if (!hits) return;

    hits.innerHTML = results.slice(0, 8).map((result, index) => {
      const item = result.item;
      const title = this.highlightMatches(item.title, result.matches, 'title');
      const content = this.highlightMatches(item.content || item.summary || '', result.matches, 'content');
      
      return `
        <section class="DocSearch-Hits">
          <div class="DocSearch-Hit-source">Results</div>
          <ul role="listbox">
            <li class="DocSearch-Hit" role="option">
              <a href="${item.permalink}">
                <div class="DocSearch-Hit-Container">
                  <div class="DocSearch-Hit-icon">
                    <svg width="20" height="20" viewBox="0 0 20 20">
                      <path d="M17 6v12c0 .52-.2 1-1 1H4c-.7 0-1-.33-1-1V2c0-.55.42-1 1-1h8l5 5zM14 8h-3.13c-.51 0-.87-.34-.87-.87V4" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  </div>
                  <div class="DocSearch-Hit-content-wrapper">
                    <span class="DocSearch-Hit-title">${title}</span>
                    ${content ? `<span class="DocSearch-Hit-path">${content.substring(0, 100)}${content.length > 100 ? '...' : ''}</span>` : ''}
                  </div>
                  <div class="DocSearch-Hit-action">
                    <svg class="DocSearch-Hit-Select-Icon" width="20" height="20" viewBox="0 0 20 20">
                      <g stroke="currentColor" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 3v4c0 2-2 4-4 4H2"/>
                        <path d="M8 17l-6-6 6-6"/>
                      </g>
                    </svg>
                  </div>
                </div>
              </a>
            </li>
          </ul>
        </section>
      `;
    }).join('');

    hits.style.display = 'block';
  }

  showNoResults(query) {
    const noResults = document.querySelector('.DocSearch-NoResults');
    const noResultsQuery = document.querySelector('.DocSearch-NoResults-Query');
    const hits = document.querySelector('.DocSearch-Hits');
    
    if (hits) hits.style.display = 'none';
    if (noResults) {
      noResults.style.display = 'block';
      if (noResultsQuery) noResultsQuery.textContent = query;
    }
  }

  clearResults() {
    const noResults = document.querySelector('.DocSearch-NoResults');
    const hits = document.querySelector('.DocSearch-Hits');
    
    if (noResults) noResults.style.display = 'none';
    if (hits) {
      hits.style.display = 'none';
      hits.innerHTML = '';
    }
  }

  highlightMatches(text, matches, key) {
    if (!matches || !text) return text;
    
    const relevantMatches = matches.filter(match => match.key === key);
    if (relevantMatches.length === 0) return text;
    
    let highlightedText = text;
    const ranges = [];
    
    relevantMatches.forEach(match => {
      match.indices.forEach(([start, end]) => {
        ranges.push({ start, end });
      });
    });
    
    // Sort ranges by start position (descending) to avoid index shifting
    ranges.sort((a, b) => b.start - a.start);
    
    ranges.forEach(({ start, end }) => {
      const before = highlightedText.slice(0, start);
      const highlighted = highlightedText.slice(start, end + 1);
      const after = highlightedText.slice(end + 1);
      highlightedText = before + `<mark>${highlighted}</mark>` + after;
    });
    
    return highlightedText;
  }
}

// Initialize search when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  // Wait for Fuse.js to be available
  if (typeof Fuse !== 'undefined') {
    new LocalSearch();
  } else {
    console.error('Fuse.js is required for search functionality');
  }
});

// Legacy docsearch function for compatibility
window.docsearch = function(options) {
  return new LocalSearch(options);
};