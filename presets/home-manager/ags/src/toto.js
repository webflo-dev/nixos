#!/usr/bin/env gjs

imports.gi.versions.Gtk = "3.0";
const { Gtk } = imports.gi;

Gtk.init(null);

const box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL });

const image = new Gtk.Image({
  vexpand: true,
});

box.add(image);

const button = Gtk.FileChooserButton.new(
  "Pick An Image",
  Gtk.FileChooserAction.OPEN,
);

button.connect("file-set", () => {
  const fileName = button.get_filename();
  image.set_from_file(fileName);
});

box.add(button);

const win = new Gtk.Window({ defaultHeight: 600, defaultWidth: 800 });
win.connect("destroy", () => {
  Gtk.main_quit();
});
win.add(box);
win.show_all();

Gtk.main();
