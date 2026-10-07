#!/usr/bin/env python3
"""Render the five canonical POSES_V2 poses to PNG for pose-table review.

Headless (SDL dummy driver) so it runs without a window; used to audit
the pose tables the same way the demo draws them.
"""
import os
os.environ.setdefault("SDL_VIDEODRIVER", "dummy")
import sys
import pygame

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import virtual_hand as vh

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                   "report")


def render_pose(screen, fonts, name, yaw, zoom=1.0, pan=(0, 0), tag=""):
    st = vh.HandState()
    st.cur = list(vh.POSES_V2[name])
    st.to = list(st.cur)
    st.cls = vh.POSE_NAMES.index(name)
    st.conf = 100
    vh.VIEW["yaw"] = yaw
    vh.VIEW["zoom"] = zoom
    vh.VIEW["pan_x"], vh.VIEW["pan_y"] = pan
    screen.fill(vh.COL["bg"])
    vh.draw_hand(screen, st)
    vh.draw_status(screen, st, fonts)
    path = os.path.join(OUT, "pose_preview_%s%s.png" % (name, tag))
    pygame.image.save(screen, path)
    print("saved", path)


def main():
    pygame.init()
    screen = pygame.display.set_mode((480, 640))
    fonts = vh.make_fonts()
    base = {"yaw": 0.0, "pitch": 34.0, "zoom": 1.0,
            "pan_x": 0.0, "pan_y": 0.0}
    vh.VIEW.update(base)
    for name in ("rest", "open", "fist", "flex", "ext"):
        render_pose(screen, fonts, name, 0.0)
    # Orbit audit: the same poses as the user sees while dragging the view.
    for name in ("rest", "fist"):
        render_pose(screen, fonts, name, 35.0)
    # Thumb-root close-ups (left palm edge where the metacarpal emerges).
    vh.VIEW.update(base)
    render_pose(screen, fonts, "fist", 0.0, zoom=2.4, pan=(95, -115),
                tag="_root")
    render_pose(screen, fonts, "rest", 0.0, zoom=2.4, pan=(95, -115),
                tag="_root")
    pygame.quit()


if __name__ == "__main__":
    main()
