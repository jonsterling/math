class InPageSearch {
  constructor() {
    this.searchResults = document.getElementById("results");
    this.form = document.querySelector("form");
    this.input = document.getElementById("search-query");
    this.bindEvents();

    this.data = [];
    this.sections = {};
    this.visibilities = {};
    this.initialized = false;
  }

  applyVisibilities() {
    Object.entries(this.visibilities).forEach(([slug, visible]) => {
      if (visible) {
        this.sections[slug].classList.remove("ellipsis");
      } else {
        this.sections[slug].classList.add("ellipsis");
      }
    });
  }

  async lazyInit() {
    if (this.initialized) return;
    document.querySelectorAll("section").forEach((element) => {
      this.sections[element.id] = element;
      this.visibilities[element.id] = true;
      const text = [...element.children]
        .filter((e) => e.nodeName != "SECTION")
        .map((e) => e.innerText)
        .join("\n");
      this.data.push({
        slug: element.id,
        text: text,
      });
    });
    this.initIndex(this.data);
    this.initialized = true;
  }

  initIndex(data) {
    this.index ||= lunr(function () {
      this.ref("slug");
      this.field("text");
      data.forEach(function (doc) {
        this.add(doc);
      }, this);
    });
  }

  searchIndex(query) {
    return this.index.search(query);
  }

  handleOnInput(event) {
    this.run(event.target.value);
  }

  async handleReset(event) {
    await this.clear();
  }

  async handleSubmit(event) {
    event.preventDefault();
    var data = new FormData(event.target);
    var q = data.get("q");
    await this.run(q);
  }

  async run(q) {
    this.lazyInit();
    // TODO: lock form
    const results = this.searchIndex(q);
    this.setAllVisibilities(false);
    await this.promiseToUnmarkDocument();
    await this.promiseToMarkDocument(results);
    this.applyVisibilities();
    // TODO: unlock form
  }

  async clear() {
    // TODO: lock form
    await this.promiseToUnmarkDocument();
    this.setAllVisibilities(true);
    this.applyVisibilities();
    // TODO: unlock form
  }

  promiseToMarkSection(section, terms) {
    return new Promise((resolve, reject) => {
      // TODO: fix spurious highlights, e.g. (co)cartesian
      new Mark(section).mark(terms, { exclude: "section", done: resolve });
    });
  }

  showSectionAndAncestors(node) {
    if (node.nodeName != "SECTION") return;
    if (this.visibilities[node.id]) return;
    this.visibilities[node.id] = true;
    this.showSectionAndAncestors(node.parentNode);
  }

  promiseToMarkDocument(results) {
    const promisesToMarkSections = results.map(
      ({ ref, matchData: { metadata } }) => {
        const section = this.sections[ref];
        this.showSectionAndAncestors(section);
        this.promiseToMarkSection(section, Object.keys(metadata));
      }
    );

    return Promise.allSettled(promisesToMarkSections);
  }

  promiseToUnmarkDocument() {
    return new Promise((resolve, reject) => {
      new Mark(document).unmark({ done: resolve });
    });
  }

  setAllVisibilities(status) {
    Object.keys(this.visibilities).forEach(
      (slug) => (this.visibilities[slug] = status)
    );
  }

  bindEvents() {
    this.form.addEventListener("submit", this.handleSubmit.bind(this), false);
    this.form.addEventListener("reset", this.handleReset.bind(this), false);
    this.input.addEventListener(
      "keydown keyup",
      this.handleOnInput.bind(this),
      false
    );
  }
}

document.addEventListener("DOMContentLoaded", function () {
  window.inPageSearch = new InPageSearch();
});
