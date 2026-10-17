# Model convert

Converts a 3D model from one format to another with `std.formats.models`, and prints what it holds: the tree of nodes with what each shows, the meshes, materials, textures, cameras, lights, skins and animations, and the file's metadata.

```bash
adm run --release gfx/model-convert/convert.adm -- gfx/model-render/models/Fox/Fox.glb fox.obj
adm run --release gfx/model-convert/convert.adm -- gfx/model-render/models/sphere.stl sphere.glb
```

Formats it reads and writes, by extension: `.gltf`, `.glb`, `.obj`, `.stl`. The input's format is found from the file's content (its extension for the text formats), the output's from its extension. Files the output format keeps beside the model are written into the output's folder: a glTF's `.bin` buffer and its images, an OBJ's `.mtl` material library and its textures.

The code is in [convert.adm](convert.adm): `models.load` reads the file into the shared `Model`, `describe` walks it, `model.save` writes it in the format the extension names. Every codec reads into and writes from the same model, so any format converts to any other; what a format cannot express (an STL has no materials, an OBJ no animations) is left out by its writer.

The fox above prints:

```
nodes:
  root
    _rootJoint
      b_Root_00
        b_Hip_01
          b_Spine01_02
            ...
  fox mesh fox1 (576 triangles) skinned
1 meshes, 576 triangles, 1728 vertices
1 materials, 1 textures, 1 embedded files
0 cameras, 0 lights, 1 skins, 3 animations
  animation Survey: 21 channels, 3.416667 s
  animation Walk: 21 channels, 0.708333 s
  animation Run: 21 channels, 1.158333 s
  copyright: CC-BY 4.0 Model by PixelMannen ...
  version: 2.0
wrote fox.obj
```
