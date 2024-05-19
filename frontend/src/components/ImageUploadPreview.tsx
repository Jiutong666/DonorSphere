import { Image } from '@nextui-org/react';
import { useRef } from 'react';

export const ImageUploadPreview = ({
  imagePreview,
  setImagePreview = () => {},
}: {
  imagePreview: string;
  setImagePreview: Function;
}) => {
  const fileInputRef = useRef();

  const handleDivClick = () => {
    fileInputRef.current.click();
  };

  const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <div className="w-[22rem]">
      <input type="file" accept="image/*" ref={fileInputRef} className="hidden" onChange={handleImageChange} />
      <div onClick={handleDivClick}>
        {!imagePreview ? (
          <Image alt="add" src="/add.svg" width={100} className="rounded-xl border-2" />
        ) : (
          <Image src={imagePreview} alt="Image Preview" className="rounded-2xl border-1 w-[22rem]" />
        )}
      </div>
    </div>
  );
};
