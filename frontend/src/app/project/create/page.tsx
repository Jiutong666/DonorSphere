import ProjectForm from '@/components/ProjectForm';

export default function Create() {
  return (
    <div className="max-w-[114rem] w-full mt-2 bg-white px-[30rem] py-10 shadow-lg h-[93vh]">
      <p className="mb-4 font-bold text-[2rem]">Create Project</p>
      <ProjectForm />
    </div>
  );
}
