import OrganizationForm from '@/components/OrganizationForm';

export default function OrgCreate() {
  return (
    <div className="max-w-[114rem] w-full mt-2 bg-white px-[30rem] py-10 shadow-lg min-h-[93vh]">
      <p className="mb-4 font-bold text-[2rem]">Create Organization</p>
      <OrganizationForm />
    </div>
  );
}
