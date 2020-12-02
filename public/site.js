var app = new Vue({
  el: '#app',
  data: {
    note: {text: "", order: null},
    newNote: "",
    sender: "",
    notesCount: 0
  },
  methods: {
    addNote: async function() {
      fetch("/notes",
        {
          method: "POST",
          mode: "same-origin",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            text: this.newNote.trim()
          })
        }
      ).then(async function(data) {
        data = await data.json();
        app.newNote = "";
        app.note = data.note;
        app.notesCount = data.notesCount;
      })
    },
    newestNote: async function() {
      fetch("/notes?query=latest").then(async function(data) {
        data = await data.json();
        app.note = data.note;
        app.notesCount = data.notesCount;
      })
    },
    previousNote: async function() {
      fetch(`/notes/${this.note.id}/previous`).then(async function(data) {
        data = await data.json();
        if (data.error && data.error.message === "There are no more notes.") {
          return false;
        }
        app.note = data;
      })
    },
    nextNote: async function() {
      fetch(`/notes/${this.note.id}/next`).then(async function(data) {
        data = await data.json();
        if (data.error && data.error.message === "There are no more notes.") {
          return false;
        }
        app.note = data;
      })
    },
    randomNote: async function() {
      fetch("/notes?query=random").then(async function(data) {
        data = await data.json();
        app.note = data;
      })
    },
    editNote: function() {
      window.location = `/notes/${this.note.id}/edit`;
    },
    logOut: function() {
      fetch("/sessions/logout",
        {
          method: "DELETE",
          mode: "same-origin",
          headers: { "Content-Type": "application/json" },
          redirect: "follow" // might not be working
        }
      ).then(function(response) {
        // manually follow redirect
        if (response.redirected) {
          window.location.href = response.url;
        }
      })
    },
  },
  beforeMount(){
    this.newestNote();
  },
});
