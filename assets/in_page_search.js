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
    Object.keys(this.visibilities).forEach(this.applyVisibility.bind(this));
  }

  applyVisibility(slug) {
    if (this.visibilities[slug]) {
      this.sections[slug].classList.remove("ellipsis");
    } else {
      this.sections[slug].classList.add("ellipsis");
    }
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
    await this.setFormLock(true);
    const results = this.searchIndex(q);
    this.setVisibilities(false);
    await this.promiseToUnmarkDocument();
    await this.promiseToMarkDocument(results);
    this.applyVisibilities();
    await this.setFormLock(false);
  }

  async clear() {
    await this.setFormLock(true);
    await this.promiseToUnmarkDocument();
    this.setVisibilities(true);
    this.applyVisibilities();
    await this.setFormLock(false);
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

  setVisibilities(status) {
    Object.keys(this.visibilities).forEach(
      this.setVisibility.bind(this, status)
    );
  }

  setVisibility(status, slug) {
    this.visibilities[slug] = status;
  }

  handleClick(event) {
    if (!this.initialized) return;
    const section = event.target.closest("section");
    if (!section) return;
    const slug = section.id;
    if (this.visibilities[slug]) return;
    this.setVisibility(true, slug);
    this.applyVisibility(slug);
  }

  bindEvents() {
    document.addEventListener("click", this.handleClick.bind(this), false);
    this.form.addEventListener("submit", this.handleSubmit.bind(this), false);
    this.form.addEventListener("reset", this.handleReset.bind(this), false);
    this.input.addEventListener(
      "keydown keyup",
      this.handleOnInput.bind(this),
      false
    );
  }

  async setFormLock(locked) {
    this.form.querySelector("fieldset").disabled = locked;
    // we need to give slow machines some time to redraw
    await this.sleep(1);
  }

  sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

document.addEventListener("DOMContentLoaded", function () {
  window.inPageSearch = new InPageSearch();
});
