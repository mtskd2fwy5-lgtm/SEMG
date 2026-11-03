"""Refresh the existing Vitis platform/FSBL after enabling the PL HP1 port.

Run with the installed Vitis: vitis.bat -s build/scripts/update_learning_platform.py
This uses the same API calls as this workspace's Vitis journals.
"""
from pathlib import Path
import vitis

root=Path(__file__).resolve().parents[2]
client=vitis.create_client()
try:
    client.set_workspace(path=str(root/'build/vitis_ws'))
    platform=client.get_component(name='platform')
    status=platform.update_hw(hw_design=str(root/'build/export/design_1.xsa'))
    if status is False:raise RuntimeError('Vitis hardware update failed')
    status=platform.build()
    if status is False:raise RuntimeError('Vitis platform / FSBL build failed')
    print('PL_LEARNING_PLATFORM_BUILD_FINISHED')
finally:
    vitis.dispose()

