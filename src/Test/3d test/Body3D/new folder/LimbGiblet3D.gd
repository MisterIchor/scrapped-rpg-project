extends BaseBody3D
class_name LimbGiblet3D

# A giblet represents any additional appendage on a LimbSection, such as eyes, ears, 
# noses, fingers, etc. Since giblets are often the weak points on limbs, they do 
# not have health like LimbSections do.
# Instead, any damage dealt to a giblets is transfered to the LimbSection's health,
# and, should enough damage be dealt, that giblet is instead considered injured 
# for the purpose of applying penalties.

# Maybe someday I'll think of something to code for this.
# Also, mesh does nothing here. Giblets don't deserve meshes.
