# Third-party notices

The repository's Apache-2.0 license applies to original project material
for which the contributors hold the necessary rights. Existing third-party
copyright notices and licenses take precedence for their respective files.

## Source Han Sans

- Source: Adobe Source Han Sans, CN Regular.
- Files: `third_party/fonts/source-han-sans/` and the font glyph data generated
  in `sw/ps_uart_print/lcd_font_zh.h` by `tools/gen_hz_glyphs.py`.
- License: SIL Open Font License 1.1, including the reserved font name terms.
- Full notice: `third_party/fonts/source-han-sans/LICENSE.txt`.
- Boot packaging also retains the notice at `build/boot/SourceHanSans-OFL.txt`.

## AMD tools, IP, and platform components

Vivado/Vitis, Zynq processing-system support, vendor IP implementations,
and BSP/platform/runtime components are subject to their upstream licenses
and tool terms. The project configuration and IP customization files do
not relicense those components under Apache-2.0. Install the vendor tools
and obtain any required licenses separately. Preserve upstream notices
when redistributing permitted generated or runtime components.

## External documentation and templates

Competition templates, vendor schematics, board manuals, and device
datasheets are not relicensed by this repository. Local reference PDFs,
unedited competition templates, and downloaded reference pages are not
part of the new open-source submission. Historical references identify
their sources; they do not grant rights to the source publications.

## License transition

Beginning with the open-source update dated 2026-11-03, original project
material is offered under Apache-2.0 with the project owner's authorization.
Earlier commits may contain the former CC BY-NC 4.0 license. Obtain the
current revision and retain its LICENSE and applicable notices. Third-party
material remains under its original terms in every revision.
