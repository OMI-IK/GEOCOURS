#!/usr/bin/env python3
import fitz
import os
import sys

pdf_path = '/home/lahiniriko/Documents/GEODE /Géoddyn-Externe-L1-Pro-GEODE.pdf'
output_dir = '/home/lahiniriko/Documents/GEOCOURS/assets/images'

# Create output directory
os.makedirs(output_dir, exist_ok=True)

print(f"Opening PDF: {pdf_path}")
doc = fitz.open(pdf_path)

print(f"PDF has {len(doc)} pages")

total_images = 0
for page_num in range(len(doc)):
    page = doc[page_num]
    images = page.get_images(full=True)
    
    print(f"\nPage {page_num + 1}: {len(images)} image(s) found")
    
    for img_index, img in enumerate(images):
        xref = img[0]
        base_image = doc.extract_image(xref)
        image_bytes = base_image["image"]
        image_ext = base_image["ext"]
        
        filename = f"page{page_num+1}_img{img_index+1}.{image_ext}"
        filepath = os.path.join(output_dir, filename)
        
        with open(filepath, "wb") as f:
            f.write(image_bytes)
        
        total_images += 1
        print(f"  ✓ Saved: {filename} ({len(image_bytes)} bytes)")

doc.close()
print(f"\n✅ Total: {total_images} images extracted to {output_dir}")

# List all extracted images
print("\n--- Extracted images ---")
for f in sorted(os.listdir(output_dir)):
    filepath = os.path.join(output_dir, f)
    size = os.path.getsize(filepath)
    print(f"  {f} ({size:,} bytes)")
