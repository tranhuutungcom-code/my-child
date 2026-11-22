
import exifr from "exifr";

export async function readPhotoDate(file: File) {
  try {
    const metadata = await exifr.parse(file);

    const date =
      metadata?.DateTimeOriginal ||
      metadata?.CreateDate ||
      metadata?.ModifyDate;

    if (date instanceof Date && !isNaN(date.getTime())) {
      return {
        date: date.toISOString(),
        source: "exif"
      };
    }
  } catch (error) {
    console.warn("Cannot read EXIF:", error);
  }

  return {
    date: null,
    source: "unknown"
  };
}
